#!/usr/bin/env bash
set -u

usage() {
  printf 'Usage: %s DOMAIN MAIL_HOST PUBLIC_IP DKIM_SELECTOR\n' "$0"
  printf 'Example: %s example.com mail.example.com 192.0.2.10 mail\n' "$0"
}

if [[ $# -ne 4 ]]; then
  usage >&2
  exit 2
fi

domain=${1%.}
mail_host=${2%.}
public_ip=$3
selector=$4

if ! command -v dig >/dev/null 2>&1; then
  printf 'dig is required.\n' >&2
  exit 2
fi

query() {
  local label=$1
  local name=$2
  local type=$3
  printf '\n## %s\n' "$label"
  dig +noall +answer "$name" "$type"
}

printf '# Mail DNS report\n'
printf 'Domain: %s\nMail host: %s\nPublic IP: %s\nSelector: %s\n' \
  "$domain" "$mail_host" "$public_ip" "$selector"

query "MX" "$domain" MX
query "Mail host A" "$mail_host" A
query "Mail host AAAA" "$mail_host" AAAA
printf '\n## PTR\n'
dig +noall +answer -x "$public_ip"
query "SPF and other root TXT" "$domain" TXT
query "DKIM" "${selector}._domainkey.${domain}" TXT
query "DMARC" "_dmarc.${domain}" TXT
query "MTA-STS" "_mta-sts.${domain}" TXT
query "TLS-RPT" "_smtp._tls.${domain}" TXT
query "MTA-STS endpoint" "mta-sts.${domain}" A

printf '\n## Consistency hints\n'
mx_targets=$(dig +short MX "$domain" | awk '{print $2}' | sed 's/\.$//' || true)
if grep -Fxq "$mail_host" <<<"$mx_targets"; then
  printf '[OK] Expected mail host is present in MX results.\n'
else
  printf '[WARN] Expected mail host was not found in MX results.\n'
fi

forward_addresses=$(dig +short A "$mail_host"; dig +short AAAA "$mail_host")
if grep -Fxq "$public_ip" <<<"$forward_addresses"; then
  printf '[OK] Public IP is present in forward results.\n'
else
  printf '[WARN] Public IP was not found in forward results.\n'
fi

ptr_name=$(dig +short -x "$public_ip" | sed 's/\.$//' | head -n1)
if [[ "$ptr_name" == "$mail_host" ]]; then
  printf '[OK] PTR matches the expected mail host.\n'
else
  printf '[WARN] PTR is "%s"; expected "%s".\n' "${ptr_name:-missing}" "$mail_host"
fi

printf '\nReview record syntax, propagation, alignment, and provider ownership manually.\n'
