# Google Sign-In setup

Google Sign-In fails on Android with this Play services log line when the
signing certificate is not registered for the app:

```
Auth.Api.Credentials: [8] Unknown error [status=UNREGISTERED_ON_API_CONSOLE]
GoogleSignInChimeraActivity: Activity finished with error.
```

The app surfaces this as a visible message and logs the failing code in debug
builds. The remaining fix is console-side.

## This machine's debug certificate

```
SHA-1:   1C:31:A6:71:CA:B3:8D:55:64:8F:33:3A:D8:89:E0:56:97:ED:97:C9
SHA-256: EC:2C:6C:E7:15:93:9E:54:E0:9E:6B:B6:4B:5C:E7:F5:8C:58:DB:88:64:39:93:9E:83:77:4F:2E:B6:BE:C2:82
```

`android/app/google-services.json` currently contains a different hash
(`6a6db722e17ecc6ff7b56c05d2429d93f19d6868`) from another machine, which is why
the account chooser opens but the sign-in is rejected afterwards.

## Steps

1. Open the Firebase console for project `movie-app-graduation`
   (project number `399080020995`).
2. Project settings -> Your apps -> Android app `com.example.movie_app`.
3. Add the SHA-1 above under "SHA certificate fingerprints".
4. Download the updated `google-services.json` into `android/app/`.
5. Rebuild and reinstall the app.

Release builds need the release keystore's SHA-1 added the same way.

## Context (Nov 25)

- Work is on branch `leftanic_dev3`, uncommitted, in stash
  `movie_app perf + responsive pass`.
- The debug APK installed on the emulator is signed with the SHA-1 above.
