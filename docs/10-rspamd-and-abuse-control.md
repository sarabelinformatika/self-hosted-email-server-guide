# 10 — Rspamd and abuse control

## Integration

Connect Rspamd to both smtpd_milters and non_smtpd_milters so inbound, locally generated, and authenticated outbound messages receive the intended processing. Confirm the actual path for every message class.

## Control layers

- Connection controls: postscreen, rate limits, reputation, and protocol correctness.
- Envelope controls: recipient existence, sender policy, HELO checks, and relay restrictions.
- Content controls: Rspamd symbols, Bayesian classification, fuzzy checks, antivirus integration when required.
- Outbound controls: per-account rate limits, DKIM signing, sender authorization, anomaly alerting.
- Administrative controls: restricted controller, protected Redis, audited changes.

## Actions

Define score thresholds for add-header, greylist or temporary failure, reject, and quarantine if implemented. Never begin with copied thresholds at full enforcement. Measure false positives with synthetic and approved test mail.

## DKIM signing

Rspamd signs only when its eligibility rules classify mail as outbound or authenticated as intended. Store keys outside the repository, restrict permissions, and validate selector/domain alignment. Rotate keys using overlapping DNS publication.

## Failure policy

milter_default_action=tempfail avoids silently bypassing filtering when the service is unavailable, but can delay all mail. Document the business-approved alternative and monitor the failure path.

## Abuse response

Alert on authentication spikes, per-user outbound volume, repeated recipients, queue growth, Rspamd reject trends, and reputation reports. A compromised account must be disabled, sessions and passwords revoked, queue content reviewed, recipients assessed, and affected credentials rotated.

## Validation

~~~bash
rspamadm configtest
rspamc stat
systemctl is-active rspamd redis-server
~~~

Use standard test messages only in an isolated or approved path. Never upload live message bodies or personal data to third-party scanners without authorization.
