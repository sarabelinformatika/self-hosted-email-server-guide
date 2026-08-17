# 16 — Lifecycle, upgrades, and decommissioning

## Monthly

- Apply or schedule security updates.
- Review certificate renewal, queue trends, authentication abuse, disk growth, and backup results.
- Review upstream Postfix, Dovecot, Rspamd, Roundcube, Debian, PHP, Nginx, Redis, and MariaDB advisories.
- Sample DMARC and TLS reports.

## Quarterly

- Restore a synthetic mailbox and configuration set.
- Review administrators, service accounts, aliases, applications, and DNS records.
- Test open-relay resistance and external TLS.
- Rotate test credentials and review key-rotation readiness.
- Reconcile documentation with postconf -n, doveconf -n, and active service inventory.

## Upgrades

Read upstream and Debian release notes. Test configuration parsing, schema migration, plugins, TLS behavior, password schemes, LMTP/auth socket ownership, Rspamd symbols, and rollback in staging.

For major Dovecot changes, do not assume 2.3 syntax is accepted by 2.4. Capture sanitized effective configuration before and after. Back up databases and config, define a maintenance window, and monitor immediately after rollout.

## Capacity

Forecast mailbox bytes, database growth, queue spikes, logs, indexes, backup duration, restore duration, and outbound throughput. Keep emergency headroom and alert before hard quotas.

## Decommissioning

1. Approve retention, export, and legal-hold actions.
2. Stop new account creation and record a final inventory.
3. Route mail to the successor and complete delta migration.
4. Retain old service read-only for the approved window.
5. Remove MX, SPF authorization, DKIM selectors after safe expiry, DMARC report routes, MTA-STS policy, TLS-RPT, autoconfig, and PTR.
6. Revoke certificates, DNS/API credentials, service accounts, and backup access.
7. Sanitize media and dispose of backups according to policy.
8. Close monitoring, documentation, contracts, and abuse contacts.

Do not release an IP address while DNS, PTR, or allowlists still associate it with the organization.
