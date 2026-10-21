#!/usr/bin/env bash

# Install or repair JDownloader for the current user on Debian/Devuan.
# JDownloader keeps its application data and updates in ~/.jd.
set -Eeuo pipefail

readonly jd_dir="${HOME}/.jd"
readonly bin_dir="${HOME}/bin"
readonly launcher="${bin_dir}/jdownloader"
readonly desktop_dir="${HOME}/.local/share/applications"
readonly bootstrap_url="https://installer.jdownloader.org/JDownloader.jar"

run_as_root() {
  if (( EUID == 0 )); then
    "$@"
  else
    # The surrounding post-install scripts may export su=doas or su=sudo.
    # shellcheck disable=SC2086
    ${su:-sudo} "$@"
  fi
}

if (( EUID == 0 )); then
  echo "Error: run this script as the desktop user, not as root." >&2
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Error: this script requires APT (Debian or Devuan)." >&2
  exit 1
fi

required_packages=(ca-certificates curl openjdk-21-jre psmisc)
missing_packages=()
for package in "${required_packages[@]}"; do
  if ! dpkg-query -W -f='${db:Status-Status}' "$package" 2>/dev/null | grep -q 'installed$'; then
    missing_packages+=("$package")
  fi
done

if ((${#missing_packages[@]})); then
  echo "Installing required packages: ${missing_packages[*]}"
  run_as_root apt-get update
  run_as_root apt-get install -y "${missing_packages[@]}"
fi

mkdir -p "$jd_dir" "$bin_dir" "$desktop_dir"

if [[ ! -s "$jd_dir/JDownloader.jar" ]]; then
  echo "Downloading the official JDownloader bootstrap..."
  temporary_jar="$(mktemp "${jd_dir}/JDownloader.jar.XXXXXX")"
  trap 'rm -f "${temporary_jar:-}"' EXIT
  curl --fail --location --retry 3 --output "$temporary_jar" "$bootstrap_url"
  chmod 0644 "$temporary_jar"
  mv -f "$temporary_jar" "$jd_dir/JDownloader.jar"
  trap - EXIT
fi

temporary_launcher="$(mktemp "${bin_dir}/.jdownloader.XXXXXX")"
trap 'rm -f "${temporary_launcher:-}"' EXIT
cat >"$temporary_launcher" <<'LAUNCHER'
#!/usr/bin/env bash
set -Eeuo pipefail

readonly jd_dir="${HOME}/.jd"
readonly command_name="$(basename "$0")"
readonly java_bin="/usr/lib/jvm/java-21-openjdk-$(dpkg --print-architecture)/bin/java"
cd "$jd_dir"

if [[ ! -x "$java_bin" ]]; then
  echo "Error: the OpenJDK 21 runtime is not installed correctly." >&2
  exit 1
fi

# A crash during startup can leave these files behind and make the next launch
# incorrectly report that JDownloader is already running.
if [[ -f JD2.lock ]] && ! fuser JD2.lock >/dev/null 2>&1; then
  rm -f JD2.lock JDownloader.pid
fi

case "$command_name" in
  JDownloaderHeadlessCleanLogin)
    settings='cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json'
    if [[ ! -f "$settings" ]]; then
      echo "There is no MyJDownloader configuration file."
      exit 0
    fi
    read -r -p "Delete the MyJDownloader configuration? Type yes to confirm: " answer
    if [[ "$answer" == yes ]]; then
      rm -f "$settings"
      echo "Configuration deleted."
    else
      echo "Aborted."
    fi
    ;;
  JDownloaderHeadlessCtl)
    action="${1:-status}"
    pid="$(fuser JD2.lock 2>/dev/null | awk '{print $NF}' || true)"
    case "$action" in
      status)
        if [[ -n "$pid" ]]; then
          echo "JDownloader is running under PID $pid"
        else
          echo "JDownloader is not running"
          exit 1
        fi
        ;;
      start)
        if [[ -n "$pid" ]]; then
          echo "JDownloader is already running under PID $pid"
        else
          nohup "$HOME/bin/JDownloaderHeadless" >JDownloader.service.log 2>&1 &
          echo "JDownloader started"
        fi
        ;;
      stop)
        if [[ -z "$pid" ]]; then
          echo "JDownloader is not running"
          exit 1
        fi
        kill "$pid"
        ;;
      *)
        echo "Usage: $command_name {start|stop|status}" >&2
        exit 2
        ;;
    esac
    ;;
  JDownloaderHeadless)
    exec "$java_bin" -Djava.awt.headless=true -jar JDownloader.jar -norestart "$@"
    ;;
  *)
    exec "$java_bin" -jar JDownloader.jar "$@"
    ;;
esac
LAUNCHER

chmod 0755 "$temporary_launcher"
mv -f "$temporary_launcher" "$launcher"
trap - EXIT

for command_name in JDownloader JDownloaderHeadless JDownloaderHeadlessCtl JDownloaderHeadlessCleanLogin; do
  ln -sfn "jdownloader" "${bin_dir}/${command_name}"
done

cat >"${desktop_dir}/jdownloader.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=JDownloader
Comment=Download manager
Exec=${launcher}
Terminal=false
Categories=Network;FileTransfer;
StartupWMClass=jd-Main
EOF

chmod 0644 "${desktop_dir}/jdownloader.desktop"

echo "JDownloader is ready. Run: jdownloader"
