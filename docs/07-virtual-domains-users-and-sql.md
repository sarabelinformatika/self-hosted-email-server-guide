# 07 — Virtual domains, users, and SQL

## Data model

Maintain explicit tables for domains, mailboxes, aliases, and optional sender authorization. Every record should have an enabled state and immutable identifier.

~~~text
domain(id, name, enabled)
mailbox(id, domain_id, local_part, password_hash, quota_bytes, enabled)
alias(id, source_address, destination_address, enabled)
~~~

Normalize domains to lower-case ASCII labels. Decide and document local-part case behavior. Prevent alias loops and unbounded catch-all aliases.

## Least privilege

Use separate accounts:

- mail_lookup for Postfix SELECT queries;
- auth_lookup for Dovecot SELECT queries;
- provisioning for approved INSERT/UPDATE actions;
- backup for controlled consistent dumps;
- database administrator for maintenance only.

Bind MariaDB to a UNIX socket or private interface. Require TLS and hostname validation if queries cross hosts.

## Query behavior

Recipient, domain, alias, password, and user lookups must return exactly the shape expected by the installed component. Treat zero, one, and multiple-row results explicitly. Log query failures without logging password hashes.

## Provisioning workflow

1. Validate domain ownership and approval.
2. Create the domain disabled.
3. Publish and verify required DNS.
4. Create mailboxes with generated initial secrets or an approved identity flow.
5. Test lookup, LMTP delivery, IMAPS, submission, quota, and disable behavior.
6. Enable service and record the change.

For deletion, disable first, retain according to policy, export when required, then purge through an approved process.

## Database resilience

Enable backups with consistent transaction semantics. Test schema and data restore into an isolated instance. Monitor connection errors, slow queries, storage, and replication if used. Mail delivery should defer, not misroute, when identity data is unavailable.

## Validation

Use a synthetic domain and user. Confirm that disabled domains, disabled users, nonexistent recipients, aliases, and quota boundaries behave predictably. Query plans and indexes must remain stable at expected scale.
