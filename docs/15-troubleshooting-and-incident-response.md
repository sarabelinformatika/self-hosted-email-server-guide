# 15 — Troubleshooting and incident response

## Triage order

1. Define scope: sender, recipient, domain, protocol, time, and queue/message ID.
2. Check current alerts and recent approved changes.
3. Confirm DNS and time.
4. Trace the SMTP transaction and queue state.
5. Inspect Rspamd decision and Dovecot delivery/authentication.
6. Reproduce with a synthetic message when safe.
7. Contain without destroying evidence.

## Common symptoms

| Symptom | First checks |
|---|---|
| Remote mail not arriving | MX, public port 25, Postfix log, recipient map, Rspamd |
| Mail deferred outbound | queue reason, DNS, route, TLS policy, reputation |
| User cannot submit | 587 TLS, SASL socket, Dovecot passdb, rate limit |
| IMAP login fails | certificate, Dovecot listener, passdb/userdb, quota/storage |
| DKIM missing | non_smtpd_milters, signing eligibility, key mode, selector DNS |
| DMARC fails | visible From alignment, SPF envelope, DKIM d= domain |
| Webmail works but client fails | protocol/port/TLS/client discovery differences |
| Disk fills | queue, logs, mailbox growth, database, inode count |

## Compromised account

Disable authentication, preserve relevant logs and queue metadata, stop or hold suspicious outbound mail through an approved action, reset credentials, invalidate sessions, check forwarding/Sieve rules, review access sources, notify security, and assess external notifications.

## Suspected server compromise

Isolate through a controlled network action, preserve volatile and persistent evidence, rotate credentials from a clean system, rebuild rather than trusting in-place cleanup, replace TLS/DKIM keys, review DNS/registrar access, and notify affected parties according to policy.

## Evidence

Do not post live headers, recipient lists, message bodies, passwords, or IP intelligence publicly. Redact minimally while preserving timestamps, queue IDs, status codes, and component versions.

Use [incident-runbook.md](../templates/incident-runbook.md) for command authorization and chronology.
