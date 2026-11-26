#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
keystore_directory="$project_root/android/keystores"
keystore_path="$keystore_directory/movie-app-development.jks"
properties_path="$project_root/android/development-signing.properties"
key_alias="movie-app-development"

if [[ -e "$keystore_path" || -e "$properties_path" ]]; then
    echo "Development signing files already exist; nothing was overwritten." >&2
    exit 1
fi

for required_command in keytool openssl; do
    if ! command -v "$required_command" >/dev/null 2>&1; then
        echo "Required command not found: $required_command" >&2
        exit 1
    fi
done

umask 077
mkdir -p "$keystore_directory"

development_store_password="$(openssl rand -hex 24)"
development_key_password="$(openssl rand -hex 24)"

cleanup_incomplete_files() {
    rm -f "$keystore_path" "$properties_path"
}
trap cleanup_incomplete_files ERR

keytool -genkeypair \
    -keystore "$keystore_path" \
    -storetype JKS \
    -alias "$key_alias" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -dname "CN=Movie App Development, OU=Development, O=Movie App Graduation, L=Cairo, ST=Cairo, C=EG" \
    -storepass "$development_store_password" \
    -keypass "$development_key_password" \
    >/dev/null

{
    printf 'storeFile=keystores/movie-app-development.jks\n'
    printf 'storePassword=%s\n' "$development_store_password"
    printf 'keyAlias=%s\n' "$key_alias"
    printf 'keyPassword=%s\n' "$development_key_password"
} >"$properties_path"

chmod 600 "$keystore_path" "$properties_path"
trap - ERR

echo "Created the ignored shared-development signing files:"
echo "  android/keystores/movie-app-development.jks"
echo "  android/development-signing.properties"
echo
echo "Certificate fingerprints to register in Firebase:"
keytool -list -v \
    -keystore "$keystore_path" \
    -alias "$key_alias" \
    -storepass "$development_store_password" \
    | sed -n -E '/^[[:space:]]*SHA(1|256):/p'
echo
echo "Share both files only through an encrypted team channel."
echo "Do not run this script separately on teammate machines; doing so creates a different certificate."
