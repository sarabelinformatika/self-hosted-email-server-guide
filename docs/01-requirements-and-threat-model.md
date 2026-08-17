# 01 — Requirements and threat model

## Outcome

A signed deployment workbook that defines why the service exists, who owns it, what it protects, and when the project must stop or roll back.

## Required decisions

Record:

- authoritative mail domains and accepted aliases;
- mailbox, daily message, attachment, and retention volumes;
- availability target, RTO, RPO, and maintenance windows;
- administrative, security, DNS, network, and business owners;
- outbound message classes: human, application, transactional, or bulk;
- jurisdictions, privacy obligations, legal hold, and deletion policy;
- approved IP addresses, provider SMTP restrictions, and reverse-DNS ownership;
- migration source, coexistence needs, and rollback window.

Do not combine marketing or bulk traffic with normal user mail on the same reputation domain or IP.

## Assets

| Asset | Security objective |
|---|---|
| Mailbox contents | Confidentiality, integrity, availability |
| Credentials | Confidentiality and rapid revocation |
| DKIM/TLS keys | Confidentiality, rotation, recoverability |
| Queue and message store | Integrity, availability, controlled retention |
| DNS zone | Integrity, change accountability |
| IP/domain reputation | Abuse resistance and observability |
| Logs | Integrity, minimization, useful retention |

## Threats

- Open relay or authenticated-account abuse.
- Password spraying, credential stuffing, and session theft.
- Spoofing from missing or weak SPF, DKIM, and DMARC policy.
- Malware, phishing, spam, and hostile attachments.
- Queue flooding, storage exhaustion, and denial of service.
- Mis-issued certificates, failed renewal, or exposed private keys.
- Compromised webmail, plugins, database, or administrator endpoint.
- DNS takeover, incorrect PTR, or registrar compromise.
- Backup disclosure and untested restoration.
- Operator error during migration, upgrade, or incident response.

## Trust assumptions

Assume the public Internet is hostile. Do not trust source IP alone for user submission. Do not treat TLS as proof of sender identity. Do not expose MariaDB, Redis, Dovecot LMTP, or administrative interfaces publicly.

## Acceptance gate

Proceed only when:

- a static public IP and matching PTR can be obtained;
- the provider permits inbound TCP 25 and outbound SMTP;
- forward and reverse DNS ownership is established;
- security patching and 24×7 abuse response have named owners;
- an independent backup destination and restore environment exist;
- the organization accepts that deliverability reputation develops over time.

If any condition fails, use a reputable relay or hosted service instead.
