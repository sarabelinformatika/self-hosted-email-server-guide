# 12 — Backup and recovery

## Scope

Back up:

- mailbox data and Sieve scripts;
- MariaDB schemas and identity data;
- Postfix, Dovecot, Rspamd, Nginx, Roundcube, firewall, and monitoring configuration;
- TLS and DKIM keys through an approved secret-backup process;
- DNS zone exports and provider-side PTR/change evidence;
- version inventory, package sources, deployment workbook, and runbooks.

Postfix queue backup is not a substitute for correct delivery recovery and may create duplicates when restored. Define queue handling separately.

## 3-2-1 characteristics

Maintain multiple copies, on different failure domains, with at least one offline or immutable copy. Encrypt backups, separate backup credentials, and monitor both backup jobs and repository integrity.

## Consistency

Coordinate database snapshots/dumps and mailbox copies. Record the exact sequence and consistency guarantees. For high write rates use supported snapshot or replication mechanisms rather than an uncoordinated filesystem copy.

## Recovery order

1. Establish a clean, patched host and trusted DNS/time.
2. Restore service configuration without starting public listeners.
3. Restore secret material with correct ownership and mode.
4. Restore MariaDB and validate identities.
5. Restore mailboxes/Sieve and validate ownership.
6. Rebuild indexes only when supported and planned.
7. Start Redis, database, Rspamd, Dovecot, Postfix, and webmail in dependency order.
8. Validate locally, then restore network exposure.
9. Reconcile queue and DNS with explicit duplicate/loss assessment.

## Restore tests

At least quarterly, restore a synthetic domain and mailbox to an isolated environment. Measure RTO/RPO, verify message counts and hashes where feasible, test IMAP/search/Sieve/submission, and record defects in the recovery-test template.

## Key recovery

Restored TLS keys may still be valid but should be reissued after suspected compromise. Restored DKIM keys require continued DNS publication; if their custody is uncertain, rotate selector and remove the old key after the safe overlap period.
