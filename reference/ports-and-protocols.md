# Ports and protocols

| Port | Protocol | Exposure | Notes |
|---:|---|---|---|
| 25/tcp | SMTP | Public | MTA-to-MTA; opportunistic TLS; no user relay |
| 587/tcp | SMTP submission | User networks/public | STARTTLS and authentication required |
| 465/tcp | Submissions | Optional | Implicit TLS; enable only when required |
| 993/tcp | IMAPS | User networks/public | Mailbox access with valid TLS |
| 443/tcp | HTTPS | Public | Roundcube and MTA-STS policy |
| 22/tcp | SSH | Management only | VPN/allowlist and key authentication |
| 24/tcp/socket | LMTP | Local/private | Prefer UNIX socket on one host |
| 4190/tcp | ManageSieve | Optional/private | TLS and authentication; expose deliberately |
| 3306/tcp/socket | MariaDB | Local/private | Prefer UNIX socket; never public |
| 6379/tcp/socket | Redis | Local/private | Never public; protect controller data |
| 11332/tcp | Rspamd proxy/Milter | Local/private | Postfix integration only |
| 11334/tcp | Rspamd controller | Management only | Authenticated and restricted |

POP3/110 and clear-text IMAP/143 are excluded from the reference design.
