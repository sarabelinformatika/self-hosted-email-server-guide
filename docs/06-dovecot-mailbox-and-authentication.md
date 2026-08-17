# 06 — Dovecot mailbox and authentication

## Version boundary

Debian 13 ships Dovecot 2.4. Its configuration model differs from 2.3 examples commonly found online. Use the installed sample configuration and the Dovecot 2.4 documentation; validate every change with doveconf.

## Responsibilities

Dovecot provides IMAPS, authentication to Postfix, LMTP delivery, Sieve filtering, mailbox quotas, and administrative mailbox tooling.

## Mail storage

Choose Maildir, dbox, or another supported format based on backup, indexing, and storage requirements. The reference design uses one non-login vmail UID/GID and separates mail by domain and user:

~~~text
/var/vmail/<domain>/<user>/
~~~

The directory must not be served by HTTP. Define ownership once and prevent webmail or database accounts from owning message files.

## Required controls

- Offer IMAPS on 993; disable clear-text authentication.
- Bind LMTP to a Postfix-accessible UNIX socket.
- Bind the Postfix auth socket with the minimum required group access.
- Use a modern password scheme supported by the installed version.
- Keep passdb and userdb queries read-only and parameterized.
- Enforce quotas with alerts before hard exhaustion.
- Enable Sieve only when rules and failure behavior are understood.
- Rate-limit authentication and integrate logs with host-level blocking or upstream controls.

## LMTP

LMTP is the recommended Dovecot delivery method for most deployments. With a single virtual UID/GID, run the LMTP service under that identity where the installed version supports it. Keep the socket local and validate its mode after every package upgrade.

## Authentication

Passwords belong in a one-way password scheme, never plaintext or reversible encryption. Prefix stored hashes with the correct scheme when required. Use doveadm pw on a protected administrative system and prevent generated values from entering shell history or tickets.

## Validation

~~~bash
doveconf --version
doveconf -n
doveadm auth test user@example.com
doveadm user user@example.com
~~~

The authentication test requests a secret interactively. Do not capture it in evidence. Test IMAPS and SMTP submission separately because a successful passdb lookup does not prove socket permissions or TLS policy.

## Recovery note

Mailbox data, Dovecot configuration, Sieve scripts, indexes, and identity records have different consistency requirements. Document whether indexes are restored or rebuilt. Never assume a filesystem copy taken during delivery is application-consistent.
