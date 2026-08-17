#!/usr/bin/env bash
set -u

if [[ $# -lt 1 || $# -gt 2 ]]; then
  printf 'Usage: %s MAIL_HOST [HTTPS_HOST]\n' "$0" >&2
  exit 2
fi

mail_host=$1
https_host=${2:-$1}

if ! command -v openssl >/dev/null 2>&1; then
  printf 'openssl is required.\n' >&2
  exit 2
fi

check_starttls() {
  local label=$1
  local port=$2
  local mode=$3
  printf '\n## %s (%s:%s)\n' "$label" "$mail_host" "$port"
  timeout 15 openssl s_client \
    -connect "${mail_host}:${port}" \
    -starttls "$mode" \
    -servername "$mail_host" \
    -verify_hostname "$mail_host" \
    -verify_return_error \
    -brief </dev/null 2>&1
}

check_tls() {
  local label=$1
  local host=$2
  local port=$3
  printf '\n## %s (%s:%s)\n' "$label" "$host" "$port"
  timeout 15 openssl s_client \
    -connect "${host}:${port}" \
    -servername "$host" \
    -verify_hostname "$host" \
    -verify_return_error \
    -brief </dev/null 2>&1
}

printf '# External TLS validation\n'
date -u '+Generated: %Y-%m-%dT%H:%M:%SZ'

result=0
check_starttls "SMTP" 25 smtp || result=1
check_starttls "Submission" 587 smtp || result=1
check_tls "IMAPS" "$mail_host" 993 || result=1
check_tls "HTTPS" "$https_host" 443 || result=1

printf '\nA successful handshake validates this client path only. Review protocol, issuer, names, and dates.\n'
exit "$result"
