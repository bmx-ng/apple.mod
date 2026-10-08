# Game Center server identity verification reference

This directory contains a small Node.js reference implementation for the
server half of `TGameCenter.FetchIdentityVerification()`. It uses only Node's
built-in APIs and requires Node.js 20 or later.

The verifier:

- accepts only Game Center certificate URLs under
  `https://static.gc.apple.com/public-key/`;
- checks the downloaded certificate's validity, Apple subject and chain to a
  root trusted by Node;
- requires an application-owned allow-list of bundle identifiers;
- requires a recent timestamp;
- reconstructs Apple's signed byte sequence using a big-endian `UInt64`;
- verifies the RSA-SHA256 PKCS#1 v1.5 signature; and
- provides a hook for atomically rejecting replayed signatures.

It is a reference component, not a ready-made web service. Integrate
`verifyGameCenterIdentity()` into the server's existing request handling,
rate-limiting, logging and session creation. The client must base64-encode the
`signature` and `salt` byte arrays before placing them in JSON:

```json
{
  "gamePlayerId": "A:_example",
  "teamPlayerId": "T:_example",
  "bundleIdentifier": "com.example.game",
  "publicKeyUrl": "https://static.gc.apple.com/public-key/example.cer",
  "signature": "base64 data",
  "salt": "base64 data",
  "timestamp": "1700000000000"
}
```

Use it from server code like this:

```js
import { verifyGameCenterIdentity } from "./gamecenter-identity-verifier.mjs";

const identity = await verifyGameCenterIdentity(requestBody, {
  expectedBundleIdentifiers: new Set(["com.example.game"]),
  consumeReplayToken: async (token, timestamp) => {
    // Atomically insert token into shared storage with an expiry. Return false
    // if it already exists. A process-local Set is not sufficient in service.
    return replayStore.insertIfAbsent(token, timestamp);
  },
});
```

For an Apple Arcade game, also pass `appleArcade: true`; Apple then signs the
`gamePlayerId` instead of the `teamPlayerId`.

The command-line wrapper is useful for manually checking a freshly captured
payload:

```sh
node gamecenter-identity-verifier.mjs payload.json com.example.game
node --test gamecenter-identity-verifier.test.mjs
```

The command-line replay set lasts only for that process. A production service
must use a shared, atomic store with an expiry at least as long as its accepted
timestamp window. Cache successfully validated certificates according to their
HTTP cache headers, but always use the URL returned in each payload rather than
hardcoding a particular certificate filename because Apple rotates it.
The sample restricts certificate downloads to Apple's current Game Center key
host. If Apple officially changes that host, update the allow-list rather than
relaxing it to arbitrary client-supplied URLs.

Game Center identifies a player to your game service; Apple explicitly says it
is not a general single-sign-on system. Create your own application session
only after verification succeeds. Treat nicknames, display names and avatars
as presentation data rather than verified identity fields.
