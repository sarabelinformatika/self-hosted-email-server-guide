# Architecture decisions

## ADR-001 — Debian 13 baseline

Status: Accepted.

Use Debian 13 stable packages as the reference platform. Pin documentation to capabilities rather than patch versions and apply Debian security updates.

## ADR-002 — Postfix and Dovecot role separation

Status: Accepted.

Postfix owns SMTP and queueing. Dovecot owns authentication, IMAP, LMTP, and mailbox storage. Integration uses protected UNIX sockets on a single host.

## ADR-003 — Rspamd provides filtering and DKIM

Status: Accepted.

Use one policy engine for spam scoring and DKIM signing to reduce duplicated Milter paths. Redis remains local/private.

## ADR-004 — SQL virtual identity

Status: Accepted.

Use MariaDB for domains, mailboxes, aliases, and credentials, with separate read-only service identities and a distinct provisioning identity.

## ADR-005 — Mailbox delivery over LMTP

Status: Accepted.

Dovecot LMTP gives explicit per-recipient delivery outcomes and integrates with quotas and Sieve.

## ADR-006 — Roundcube is an untrusted-facing client

Status: Accepted.

Roundcube receives no direct access to mailbox files or signing keys and uses normal IMAPS/submission interfaces.

## ADR-007 — Read-only repository scripts

Status: Accepted.

Repository scripts collect facts and validate endpoints. Deployment mutations remain manual, reviewed change actions until purpose-built automation is added.
