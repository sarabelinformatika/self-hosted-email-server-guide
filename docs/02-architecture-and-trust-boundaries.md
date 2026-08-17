# 02 — Architecture and trust boundaries

## Reference flow

~~~text
Internet MTAs
     |
 TCP 25
     v
Postfix SMTP ----> Rspamd/Redis
     |                 |
     | LMTP            | verdict + DKIM signing
     v                 |
Dovecot mail store <---+
     ^
     | IMAPS 993 / submission 587
Users and Roundcube
     |
     +--> MariaDB virtual identity lookups
~~~

Roundcube is a client, not an authority. Postfix controls SMTP policy; Dovecot owns mailbox access and authentication; Rspamd produces content and reputation decisions; MariaDB stores virtual identity metadata.

## Zones

| Zone | Exposed services | Required control |
|---|---|---|
| Public SMTP | 25/tcp | Rate limits, postscreen, Rspamd, opportunistic TLS |
| User access | 587/tcp, 993/tcp, 443/tcp | Valid TLS, authentication, throttling |
| Administrative | SSH and dashboards | VPN or allowlist, MFA upstream, audited access |
| Local service | LMTP, SASL socket, Redis, SQL | UNIX sockets or loopback/private network |
| Backup | Repository endpoint | Separate credentials and failure domain |

## Deployment patterns

### Single host

Appropriate for a small organization when outage tolerance is documented. Bind internal services to UNIX sockets or loopback, isolate service accounts, and keep backups off-host.

### Split roles

Use separate edge MTA, mailbox, database, and webmail nodes when risk, capacity, or availability justify the complexity. Encrypt internal traffic, authenticate service identities, and document failure behavior.

## Mandatory invariants

- Only Postfix receives public SMTP.
- Port 25 never grants relay rights based on authentication intended for submission.
- Port 587 requires authentication and TLS before credentials.
- Dovecot LMTP and auth sockets have explicit ownership and modes.
- SQL identities have only the SELECT rights needed by Postfix and Dovecot; administrative writes use a separate identity.
- Rspamd controller and Redis are not public.
- Webmail cannot read TLS or DKIM private keys.

## Failure design

Decide whether filtering failure rejects, defers, or accepts mail. Default to temporary failure for uncertain security state, but evaluate business impact. Never silently discard accepted mail. Size queues and monitoring for downstream mailbox outages.

## Evidence

Capture an architecture diagram, data-flow inventory, firewall matrix, service-account matrix, and decision records before implementation.
