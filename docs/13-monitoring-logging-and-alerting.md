# 13 — Monitoring, logging, and alerting

## Service health

Monitor Postfix, Dovecot, Rspamd, Redis, MariaDB, Nginx, PHP runtime, time synchronization, DNS resolution, and the ACME renewal timer.

## Signals

| Signal | Alert intent |
|---|---|
| SMTP/IMAP/HTTPS probe | User-visible availability and TLS |
| Certificate days remaining | Renewal failure before outage |
| Queue size and oldest age | Delivery impairment or abuse |
| Deferred reason distribution | DNS, TLS, reputation, or destination faults |
| Auth failures by account/source | Spray or compromise |
| Outbound volume by account/domain | Account abuse |
| Rspamd action/symbol trends | Attack or false-positive shift |
| Disk/inode usage | Prevent queue/mailbox/database exhaustion |
| Database/Redis latency | Identity or filter degradation |
| DMARC/TLS aggregate reports | External authentication and transport faults |

Use rates and baselines, not only static thresholds.

## Log handling

Centralize relevant journals securely. Minimize message content and personal data, restrict access, encrypt transport/storage, define retention, and protect time accuracy. Do not enable verbose authentication or SQL logging in production unless time-bounded and approved.

## Synthetic monitoring

Send a uniquely tagged synthetic message through an external path, confirm receipt, and avoid looping or flooding. Synthetic accounts must be isolated from user data and excluded from business workflows.

## Dashboards

Create views for service status, mail flow, security, capacity, and certificate/DNS posture. A green daemon state is not proof that external mail works.

## Runbook links

Every actionable alert should identify owner, severity, evidence query, containment option, rollback, and escalation. Tune or remove alerts that are not actionable.
