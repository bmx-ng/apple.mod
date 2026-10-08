import {
  X509Certificate,
  constants,
  createHash,
  verify as verifySignature,
} from "node:crypto";
import { readFile } from "node:fs/promises";
import { rootCertificates } from "node:tls";
import { fileURLToPath } from "node:url";

const GAME_CENTER_KEY_HOST = "static.gc.apple.com";
const MAX_CERTIFICATE_BYTES = 64 * 1024;
const MAX_CHAIN_DEPTH = 5;
const AIA_HOSTS = new Set([
  "cacerts.digicert.com",
  "certs.apple.com",
  "www.apple.com",
]);

function decodeBase64(value, field) {
  if (typeof value !== "string" || !/^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(value)) {
    throw new Error(`${field} must be canonical base64`);
  }
  return Buffer.from(value, "base64");
}

function parseTimestamp(value) {
  if (typeof value !== "string" && typeof value !== "number") {
    throw new Error("timestamp must be an integer or decimal string");
  }
  if (typeof value === "number" && (!Number.isSafeInteger(value) || value < 0)) {
    throw new Error("numeric timestamp must be a non-negative safe integer");
  }
  if (typeof value === "string" && !/^\d+$/.test(value)) {
    throw new Error("timestamp must contain decimal digits only");
  }
  const timestamp = BigInt(value);
  if (timestamp > 0xffffffffffffffffn) {
    throw new Error("timestamp does not fit an unsigned 64-bit integer");
  }
  return timestamp;
}

function requireString(value, field) {
  if (typeof value !== "string" || value.length === 0) {
    throw new Error(`${field} must be a non-empty string`);
  }
  return value;
}

export function buildSignedData(payload, { appleArcade = false } = {}) {
  const playerId = requireString(
    appleArcade ? payload.gamePlayerId : payload.teamPlayerId,
    appleArcade ? "gamePlayerId" : "teamPlayerId",
  );
  const bundleIdentifier = requireString(payload.bundleIdentifier, "bundleIdentifier");
  const timestamp = parseTimestamp(payload.timestamp);
  const salt = decodeBase64(payload.salt, "salt");
  const timestampBytes = Buffer.alloc(8);
  timestampBytes.writeBigUInt64BE(timestamp);

  return Buffer.concat([
    Buffer.from(playerId, "utf8"),
    Buffer.from(bundleIdentifier, "utf8"),
    timestampBytes,
    salt,
  ]);
}

function assertGameCenterKeyUrl(value) {
  const url = new URL(requireString(value, "publicKeyUrl"));
  if (
    url.protocol !== "https:" ||
    url.hostname !== GAME_CENTER_KEY_HOST ||
    (url.port && url.port !== "443") ||
    url.username ||
    url.password ||
    url.search ||
    url.hash ||
    !url.pathname.startsWith("/public-key/") ||
    !url.pathname.endsWith(".cer")
  ) {
    throw new Error("publicKeyUrl is not an allowed Game Center certificate URL");
  }
  return url;
}

function assertAiaUrl(value) {
  const url = new URL(value);
  if (
    !["http:", "https:"].includes(url.protocol) ||
    !AIA_HOSTS.has(url.hostname) ||
    url.username ||
    url.password ||
    url.port ||
    url.search ||
    url.hash
  ) {
    throw new Error(`certificate contains a disallowed issuer URL: ${url}`);
  }
  return url;
}

async function downloadCertificate(url, fetchImpl) {
  const response = await fetchImpl(url, {
    redirect: "error",
    signal: AbortSignal.timeout(5000),
  });
  if (!response.ok) {
    throw new Error(`certificate download failed with HTTP ${response.status}`);
  }
  const declaredLength = Number(response.headers.get("content-length") || 0);
  if (declaredLength > MAX_CERTIFICATE_BYTES) {
    throw new Error("certificate response is too large");
  }
  const bytes = Buffer.from(await response.arrayBuffer());
  if (bytes.length === 0 || bytes.length > MAX_CERTIFICATE_BYTES) {
    throw new Error("certificate response has an invalid size");
  }
  return new X509Certificate(bytes);
}

function isCurrentlyValid(certificate, now) {
  const validFrom = Date.parse(certificate.validFrom);
  const validTo = Date.parse(certificate.validTo);
  return Number.isFinite(validFrom) && Number.isFinite(validTo) && now >= validFrom && now <= validTo;
}

function isIssuedBy(certificate, issuer) {
  return certificate.issuer === issuer.subject && certificate.verify(issuer.publicKey);
}

function issuerUrls(certificate) {
  const urls = [];
  const pattern = /CA Issuers\s*-\s*URI:([^\n]+)/g;
  for (const match of certificate.infoAccess.matchAll(pattern)) {
    urls.push(match[1].trim());
  }
  return urls;
}

const trustedRoots = rootCertificates.map((pem) => new X509Certificate(pem));

async function verifyCertificateChain(leaf, fetchImpl, now) {
  if (!isCurrentlyValid(leaf, now)) {
    throw new Error("Game Center signing certificate is outside its validity period");
  }
  if (!/(?:^|\n)O=Apple Inc\.(?:$|\n)/.test(leaf.subject)) {
    throw new Error("Game Center signing certificate is not issued to Apple Inc.");
  }

  let certificate = leaf;
  for (let depth = 0; depth < MAX_CHAIN_DEPTH; depth += 1) {
    const root = trustedRoots.find((candidate) => isIssuedBy(certificate, candidate));
    if (root) {
      if (!isCurrentlyValid(root, now)) {
        throw new Error("trusted certificate root is outside its validity period");
      }
      return;
    }

    const urls = issuerUrls(certificate);
    if (urls.length === 0) {
      throw new Error("certificate chain does not terminate at a trusted root");
    }
    const issuer = await downloadCertificate(assertAiaUrl(urls[0]), fetchImpl);
    if (!issuer.ca || !isCurrentlyValid(issuer, now) || !isIssuedBy(certificate, issuer)) {
      throw new Error("certificate issuer is invalid");
    }
    certificate = issuer;
  }
  throw new Error("certificate chain is too deep");
}

export function verifyPayloadSignature(payload, publicKey, options = {}) {
  const signature = decodeBase64(payload.signature, "signature");
  const signedData = buildSignedData(payload, options);
  return verifySignature(
    "RSA-SHA256",
    signedData,
    { key: publicKey, padding: constants.RSA_PKCS1_PADDING },
    signature,
  );
}

export async function verifyGameCenterIdentity(payload, options) {
  const {
    expectedBundleIdentifiers,
    appleArcade = false,
    maxAgeMilliseconds = 5 * 60 * 1000,
    allowedClockSkewMilliseconds = 30 * 1000,
    now = Date.now(),
    fetchImpl = fetch,
    consumeReplayToken,
  } = options ?? {};

  if (!(expectedBundleIdentifiers instanceof Set) || expectedBundleIdentifiers.size === 0) {
    throw new Error("expectedBundleIdentifiers must be a non-empty Set");
  }
  const bundleIdentifier = requireString(payload.bundleIdentifier, "bundleIdentifier");
  if (!expectedBundleIdentifiers.has(bundleIdentifier)) {
    throw new Error("bundle identifier is not allowed");
  }

  const timestamp = parseTimestamp(payload.timestamp);
  if (timestamp > BigInt(Number.MAX_SAFE_INTEGER)) {
    throw new Error("timestamp is outside JavaScript's safe date range");
  }
  const timestampNumber = Number(timestamp);
  if (timestampNumber < now - maxAgeMilliseconds || timestampNumber > now + allowedClockSkewMilliseconds) {
    throw new Error("identity payload timestamp is not recent");
  }

  const certificateUrl = assertGameCenterKeyUrl(payload.publicKeyUrl);
  const certificate = await downloadCertificate(certificateUrl, fetchImpl);
  await verifyCertificateChain(certificate, fetchImpl, now);

  if (!verifyPayloadSignature(payload, certificate.publicKey, { appleArcade })) {
    throw new Error("Game Center identity signature is invalid");
  }

  if (typeof consumeReplayToken !== "function") {
    throw new Error("consumeReplayToken is required for replay protection");
  }
  const signature = decodeBase64(payload.signature, "signature");
  const replayToken = createHash("sha256").update(signature).digest("hex");
  if (!(await consumeReplayToken(replayToken, timestampNumber))) {
    throw new Error("Game Center identity payload has already been used");
  }

  return {
    playerId: appleArcade ? payload.gamePlayerId : payload.teamPlayerId,
    bundleIdentifier,
    timestamp: timestampNumber,
  };
}

async function main() {
  const [payloadPath, expectedBundleIdentifier] = process.argv.slice(2);
  if (!payloadPath || !expectedBundleIdentifier) {
    console.error("usage: node gamecenter-identity-verifier.mjs PAYLOAD.json EXPECTED_BUNDLE_ID");
    process.exitCode = 2;
    return;
  }
  const payload = JSON.parse(await readFile(payloadPath, "utf8"));
  const consumed = new Set();
  const result = await verifyGameCenterIdentity(payload, {
    expectedBundleIdentifiers: new Set([expectedBundleIdentifier]),
    consumeReplayToken: async (token) => {
      if (consumed.has(token)) return false;
      consumed.add(token);
      return true;
    },
  });
  console.log(JSON.stringify(result, null, 2));
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
}
