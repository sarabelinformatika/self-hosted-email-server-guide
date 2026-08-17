#!/usr/bin/env bash
set -u

# Read-only host readiness report. No configuration is changed.
failures=0
warnings=0

section() { printf '\n## %s\n' "$1"; }
ok() { printf '[OK] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; warnings=$((warnings + 1)); }
fail() { printf '[FAIL] %s\n' "$1"; failures=$((failures + 1)); }

section "Identity"
hostname_fqdn=$(hostname -f 2>/dev/null || true)
if [[ -n "$hostname_fqdn" && "$hostname_fqdn" == *.* ]]; then
  ok "FQDN: $hostname_fqdn"
else
  fail "hostname -f did not return a qualified name"
fi

section "Operating system"
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  printf 'System: %s\n' "${PRETTY_NAME:-unknown}"
  if [[ "${ID:-}" == "debian" && "${VERSION_ID:-}" == "13" ]]; then
    ok "Debian 13 baseline detected"
  else
    warn "Reference baseline is Debian 13; validate all syntax and packages"
  fi
else
  warn "/etc/os-release is unavailable"
fi

section "Time"
if command -v timedatectl >/dev/null 2>&1; then
  timedatectl show -p NTPSynchronized -p Timezone --value 2>/dev/null || true
  if [[ "$(timedatectl show -p NTPSynchronized --value 2>/dev/null || true)" == "yes" ]]; then
    ok "Clock reports synchronized"
  else
    warn "Clock does not report NTP synchronization"
  fi
else
  warn "timedatectl not found"
fi

section "Name resolution"
if command -v getent >/dev/null 2>&1 && [[ -n "$hostname_fqdn" ]]; then
  if getent ahosts "$hostname_fqdn" >/dev/null 2>&1; then
    ok "FQDN resolves locally"
    getent ahosts "$hostname_fqdn" | awk '!seen[$1]++ {print "  " $1}'
  else
    fail "FQDN does not resolve locally"
  fi
fi

section "Storage"
df -hPT / /var /var/log 2>/dev/null | awk '!seen[$0]++'
df -Pi / /var /var/log 2>/dev/null | awk '!seen[$0]++'
while read -r mount used; do
  used=${used%%%}
  if [[ "$used" =~ ^[0-9]+$ && "$used" -ge 90 ]]; then
    fail "Filesystem $mount is ${used}% full"
  elif [[ "$used" =~ ^[0-9]+$ && "$used" -ge 80 ]]; then
    warn "Filesystem $mount is ${used}% full"
  fi
done < <(df -P / /var /var/log 2>/dev/null | awk 'NR>1 {print $6, $5}' | sort -u)

section "Listening sockets"
if command -v ss >/dev/null 2>&1; then
  ss -lntup 2>/dev/null || ss -lntp 2>/dev/null || true
else
  warn "ss not found"
fi

section "Mail packages"
for command_name in postconf doveconf rspamadm redis-cli mariadb nginx openssl dig; do
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name available"
  else
    warn "$command_name not installed"
  fi
done

section "Firewall"
if command -v nft >/dev/null 2>&1; then
  if nft list ruleset >/dev/null 2>&1; then
    ok "nftables ruleset readable"
    nft list ruleset 2>/dev/null
  else
    warn "nftables ruleset requires elevated read access or is unavailable"
  fi
else
  warn "nft command not found"
fi

section "Summary"
printf 'Failures: %d\nWarnings: %d\n' "$failures" "$warnings"
printf 'This report is read-only and does not prove Internet reachability, relay safety, or deliverability.\n'
(( failures == 0 ))
