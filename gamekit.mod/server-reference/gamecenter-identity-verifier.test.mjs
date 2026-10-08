import assert from "node:assert/strict";
import { generateKeyPairSync, sign } from "node:crypto";
import test from "node:test";

import {
  buildSignedData,
  verifyGameCenterIdentity,
  verifyPayloadSignature,
} from "./gamecenter-identity-verifier.mjs";

const payload = {
  gamePlayerId: "A:_arcade-player",
  teamPlayerId: "T:_team-player",
  bundleIdentifier: "com.example.game",
  publicKeyUrl: "https://static.gc.apple.com/public-key/current.cer",
  salt: Buffer.from([0xde, 0xad, 0xbe, 0xef]).toString("base64"),
  timestamp: "72623859790382856",
};

test("buildSignedData uses team player ID and a big-endian UInt64", () => {
  const data = buildSignedData(payload);
  const prefix = Buffer.from("T:_team-playercom.example.game", "utf8");
  assert.deepEqual(data.subarray(0, prefix.length), prefix);
  assert.deepEqual(data.subarray(prefix.length, prefix.length + 8), Buffer.from("0102030405060708", "hex"));
  assert.deepEqual(data.subarray(-4), Buffer.from("deadbeef", "hex"));
});

test("Apple Arcade payloads use gamePlayerId", () => {
  const data = buildSignedData(payload, { appleArcade: true });
  assert.equal(data.subarray(0, "A:_arcade-player".length).toString(), "A:_arcade-player");
});

test("RSA-SHA256 PKCS#1 v1.5 signatures verify", () => {
  const { privateKey, publicKey } = generateKeyPairSync("rsa", { modulusLength: 2048 });
  const signature = sign("RSA-SHA256", buildSignedData(payload), privateKey);
  const signedPayload = { ...payload, signature: signature.toString("base64") };
  assert.equal(verifyPayloadSignature(signedPayload, publicKey), true);

  signedPayload.teamPlayerId = "T:_other-player";
  assert.equal(verifyPayloadSignature(signedPayload, publicKey), false);
});

test("malformed base64 is rejected", () => {
  assert.throws(() => buildSignedData({ ...payload, salt: "not base64!" }), /canonical base64/);
});

test("an unexpected bundle identifier is rejected before network access", async () => {
  await assert.rejects(
    verifyGameCenterIdentity(payload, {
      expectedBundleIdentifiers: new Set(["com.example.other"]),
      now: Number(payload.timestamp),
      consumeReplayToken: async () => true,
      fetchImpl: async () => assert.fail("certificate must not be fetched"),
    }),
    /bundle identifier is not allowed/,
  );
});

test("a stale timestamp is rejected before network access", async () => {
  await assert.rejects(
    verifyGameCenterIdentity({ ...payload, timestamp: "1000" }, {
      expectedBundleIdentifiers: new Set([payload.bundleIdentifier]),
      now: 1_000_000,
      maxAgeMilliseconds: 1000,
      consumeReplayToken: async () => true,
      fetchImpl: async () => assert.fail("certificate must not be fetched"),
    }),
    /timestamp is not recent/,
  );
});
