#!/bin/bash

# Install the latest OpenJDK 25 package published for Debian/Devuan stable.
set -Eeuo pipefail

readonly package="openjdk-25-jdk"

# Use the same privilege-command convention as the other post-install scripts.
if [ "$(id -u)" -eq 0 ]; then
  su=""
elif [ -z "${su+x}" ]; then
  su="sudo"
fi

if ! command -v apt-get >/dev/null 2>&1 || ! command -v apt-cache >/dev/null 2>&1; then
  echo "Error: this script requires a Debian-compatible APT installation." >&2
  exit 1
fi

if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  case "${ID:-}" in
    debian|devuan) ;;
    *)
      echo "Warning: ${PRETTY_NAME:-this system} is not Debian or Devuan; continuing because APT is available." >&2
      ;;
  esac
fi

echo "Updating APT package metadata..."
$su apt-get update

candidate="$(apt-cache policy "$package" | awk '/Candidate:/ { print $2; exit }')"
if [ -z "$candidate" ] || [ "$candidate" = "(none)" ]; then
  echo "Error: $package is not available from the configured APT repositories." >&2
  echo "Debian 13 (trixie) or Devuan 6 (excalibur), including security updates, is required." >&2
  exit 1
fi

echo "Installing $package $candidate..."
$su apt-get install -y --no-install-recommends "$package"

java_home="$(dirname "$(dirname "$(dpkg-query -L "$package" | awk '/\/bin\/javac$/ { print; exit }')")")"

echo
echo "Installed OpenJDK:"
"$java_home/bin/java" -version
"$java_home/bin/javac" -version
echo "JAVA_HOME=$java_home"

if command -v java >/dev/null 2>&1; then
  default_java="$(readlink -f "$(command -v java)")"
  if [ "$default_java" != "$java_home/bin/java" ]; then
    echo
    echo "OpenJDK 25 was installed, but another Java is still the default."
    echo "Run ./13.set_java_version.sh if you want to change it."
  fi
fi
