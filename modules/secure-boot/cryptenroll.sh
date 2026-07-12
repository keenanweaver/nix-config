# shellcheck shell=bash
if [ $# -lt 1 ]; then
  echo "Usage: cryptenroll <device> [extra systemd-cryptenroll args...]" >&2
  exit 1
fi

device="$1"
shift

exec systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0,2,7 --tpm2-with-pin=yes "${device}" "$@"
