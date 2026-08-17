# Security control catalog

| ID | Control | Evidence |
|---|---|---|
| NET-01 | Only approved public ports are reachable | External scan and firewall export |
| SMTP-01 | Unauthenticated external relay is rejected | Negative relay test |
| SMTP-02 | Unknown recipients are rejected during SMTP | Synthetic RCPT test |
| AUTH-01 | Submission requires TLS and authentication | External handshake/test |
| AUTH-02 | Password hashes use approved one-way scheme | Sanitized schema/config review |
| DATA-01 | Mail store and database have least-privilege ownership | File and grant inventory |
| DATA-02 | Backups are encrypted and isolated | Backup policy and restore record |
| DNS-01 | A/AAAA, MX, and PTR identities are consistent | DNS validation output |
| DNS-02 | SPF, DKIM, and DMARC are valid and aligned | Header and DNS evidence |
| TLS-01 | Public services present valid certificates | External TLS checks |
| TLS-02 | Renewal is automatic and monitored | Timer/job and expiry alert |
| ABUSE-01 | Inbound filtering and outbound anomaly detection operate | Rspamd stats and alert test |
| WEB-01 | Roundcube installer and non-public paths are inaccessible | HTTP test |
| OPS-01 | Queue, storage, auth, and service health are monitored | Dashboard and alert routing |
| IR-01 | Compromise runbook has named owners | Approved incident template |
| REC-01 | Isolated restore meets RTO/RPO | Recovery test record |
