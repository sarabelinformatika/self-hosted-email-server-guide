#!/usr/bin/env bash
set -u

# Read-only health snapshot. Run with sufficient privileges to see service state.
services=(postfix dovecot rspamd redis-server mariadb nginx)
failed=0

printf '# Mail stack health snapshot\n'
date -u '+Generated: %Y-%m-%dT%H:%M:%SZ'
printf 'Host: %s\n' "$(hostname -f 2>/dev/null || hostname)"

printf '\n## Services\n'
for service_name in "${services[@]}"; do
  if systemctl is-active --quiet "$service_name" 2>/dev/null; then
    printf '[OK] %s active\n' "$service_name"
  else
    printf '[FAIL] %s not active or not installed\n' "$service_name"
    failed=$((failed + 1))
  fi
done

printf '\n## Configuration parsers\n'
if command -v postfix >/dev/null 2>&1; then
  if postfix check >/dev/null 2>&1; then
    printf '[OK] postfix check\n'
  else
    printf '[FAIL] postfix check\n'
    failed=$((failed + 1))
  fi
  postconf mail_version 2>/dev/null || true
fi

if command -v doveconf >/dev/null 2>&1; then
  if doveconf -n >/dev/null 2>&1; then
    printf '[OK] doveconf -n\n'
  else
    printf '[FAIL] doveconf -n\n'
    failed=$((failed + 1))
  fi
  doveconf --version 2>/dev/null || true
fi

if command -v rspamadm >/dev/null 2>&1; then
  if rspamadm configtest >/dev/null 2>&1; then
    printf '[OK] rspamadm configtest\n'
  else
    printf '[FAIL] rspamadm configtest\n'
    failed=$((failed + 1))
  fi
fi

if command -v nginx >/dev/null 2>&1; then
  if nginx -t >/dev/null 2>&1; then
    printf '[OK] nginx -t\n'
  else
    printf '[FAIL] nginx -t\n'
    failed=$((failed + 1))
  fi
fi

printf '\n## Queue\n'
if command -v postqueue >/dev/null 2>&1; then
  postqueue -p 2>&1 | tail -n 25
else
  printf 'postqueue unavailable\n'
fi

printf '\n## Capacity\n'
df -hPT / /var /var/log /var/vmail 2>/dev/null | awk '!seen[$0]++'
df -Pi / /var /var/log /var/vmail 2>/dev/null | awk '!seen[$0]++'

printf '\n## Failed units\n'
systemctl --failed --no-pager 2>/dev/null || true

printf '\n## Summary\nFailures: %d\n' "$failed"
printf 'No configuration, queue item, message, or service state was changed.\n'
(( failed == 0 ))
