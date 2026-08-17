# 05 — Postfix mail flow

## Responsibilities

Postfix accepts mail for authoritative domains, performs envelope and relay policy, hands content to Rspamd, delivers local recipients to Dovecot over LMTP, and queues outbound delivery.

## Listener separation

| Listener | Clients | Policy |
|---|---|---|
| SMTP 25 | Other MTAs | No user relay; opportunistic TLS; strict recipient validation |
| Submission 587 | Authenticated users/apps | STARTTLS required; SASL required; sender policy |
| Submissions 465 | Optional legacy/managed clients | Implicit TLS; SASL required |

Do not reuse port 25 restrictions on submission without understanding the difference between MTA delivery and message submission.

## Core invariants

- mydestination contains only system-local destinations.
- Virtual domains are resolved through explicit maps.
- reject_unauth_destination is present in relay restrictions.
- mynetworks is minimal and never contains broad cloud or LAN ranges without review.
- Relay rights require either an authorized network or successful authentication.
- Unknown virtual recipients are rejected during SMTP, not accepted and bounced later.
- Content filtering uses supported Milter integration and has a documented failure action.

## Version-aware skeleton

The following is a policy illustration, not a complete configuration:

~~~text
smtpd_relay_restrictions =
    permit_mynetworks
    permit_sasl_authenticated
    reject_unauth_destination

smtpd_tls_security_level = may
smtpd_tls_auth_only = yes

smtpd_milters = inet:127.0.0.1:11332
non_smtpd_milters = inet:127.0.0.1:11332
milter_protocol = 6
milter_default_action = tempfail

virtual_transport = lmtp:unix:private/dovecot-lmtp
~~~

Validate parameter availability with postconf on the installed Postfix version.

## Submission controls

Require TLS before AUTH, use Dovecot SASL over a protected UNIX socket, normalize authenticated sender identity, rate-limit compromised accounts, and apply message/recipient size limits. Application accounts should have distinct credentials and sender scope.

## Queue operations

Monitor active, deferred, hold, and corrupt queues. A growing deferred queue is a symptom, not a reason to flush repeatedly. Preserve queue IDs when escalating. Never delete queued mail before classifying the cause and recording business approval.

Read-only triage:

~~~bash
postqueue -p
postconf -n
journalctl -u postfix --since "-30 minutes"
~~~

## Validation

1. Confirm unauthenticated relay to an external domain is rejected.
2. Confirm mail to a nonexistent local user is rejected at RCPT.
3. Confirm submission without TLS cannot authenticate.
4. Confirm authenticated submission preserves a traceable user identity.
5. Confirm local delivery traverses Rspamd and LMTP.
6. Confirm outbound mail has the expected HELO, PTR, TLS behavior, and DKIM signature.

Rollback means restoring the last known configuration and maps, validating with postfix check, then reloading. Do not restart blindly during an active queue incident.
