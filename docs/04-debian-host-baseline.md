# 04 — Debian host baseline

## Baseline

Use a supported Debian 13 installation with minimal packages, accurate time, predictable addressing, and a resolvable FQDN. Apply firmware and security updates before mail data is introduced.

## Host preparation

1. Set the canonical hostname and verify forward and reverse resolution.
2. Configure at least two reliable DNS resolvers; use DNSSEC validation where operationally supported.
3. Enable time synchronization and alert on clock drift.
4. Create named administrator accounts; prohibit shared credentials.
5. Use SSH keys, restrict source networks, and disable password login after access is proven.
6. Configure nftables with an explicit inbound allowlist.
7. Enable automatic security-update notification; choose scheduled or automatic installation according to change policy.
8. Allocate separate capacity thresholds for system, logs, mail store, database, queue, and backups.

## Package baseline

The reference roles require Postfix, Dovecot IMAP/LMTP/Sieve and SQL support, MariaDB, Rspamd, Redis, Nginx, PHP components, an ACME client, and diagnostic tools. Resolve package names from the active Debian repositories rather than pasting an old package list.

~~~bash
apt-cache policy postfix dovecot-core rspamd redis-server mariadb-server nginx
postconf mail_version
doveconf --version
rspamadm --version
~~~

These commands are informational. Record output in the deployment evidence.

## Hardening

- Keep AppArmor enabled and investigate denials before adding exceptions.
- Use restrictive umasks for key and secret creation.
- Keep service secrets outside the repository and readable only by the required service account.
- Configure log rotation before production traffic.
- Disable unused protocols such as POP3 and clear-text IMAP.
- Do not enable kernel or sysctl tuning copied from unrelated high-volume deployments.

## Acceptance

Run the preflight script. Resolve hostname, time, storage, firewall, and port conflicts before installing the mail roles. Snapshotting a VM is not a replacement for an application-consistent backup.
