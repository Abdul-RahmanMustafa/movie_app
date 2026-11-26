# Google Sign-In troubleshooting

On Android, Play services can reject Google Sign-In with
`UNREGISTERED_ON_API_CONSOLE` when the APK signing certificate is not
registered for the Firebase Android application.

This project uses the shared development certificate documented in the root
`README.md`. Teammates should obtain the ignored keystore and signing
properties through the approved encrypted channel instead of generating a new
certificate on every machine.

If the account chooser opens but authentication is rejected:

1. Confirm the debug variant uses the shared development signing configuration.
2. Confirm both shared SHA fingerprints are registered for Android package
   `com.example.movie_app` in Firebase project `movie-app-graduation`.
3. Confirm `android/app/google-services.json` was downloaded after registering
   the shared certificate.
4. Uninstall any copy signed with a different local debug certificate, then
   install the shared-development build again.

The application surfaces a user-friendly provider-configuration error and
prints the Google Sign-In failure code in debug logs. Never include signing
passwords, private keystores, OAuth tokens, or private keys in logs or issues.

Production signing remains separate and must use its own Firebase certificate
registration and protected release credentials.
