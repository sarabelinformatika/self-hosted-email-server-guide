# 03 — DNS and network prerequisites

## Before installation

Reserve a stable public IPv4 address; add IPv6 only when forward DNS, PTR, routing, and filtering are equally correct. Confirm that the hosting provider does not block inbound or outbound TCP 25.

Use a dedicated hostname such as mail.example.com. Its A/AAAA records must resolve to the addresses used by Postfix, and each address must reverse-resolve to the same canonical hostname.

## Minimum DNS plan

| Name | Type | Purpose |
|---|---|---|
| example.com | MX | Routes inbound mail to mail.example.com |
| mail.example.com | A/AAAA | Mail host address |
| public address | PTR | Reverse identity controlled by provider |
| example.com | TXT | SPF authorization |
| selector._domainkey.example.com | TXT | DKIM public key |
| _dmarc.example.com | TXT | DMARC policy and reports |
| _mta-sts.example.com | TXT | MTA-STS policy version |
| mta-sts.example.com | A/AAAA | HTTPS policy endpoint |
| _smtp._tls.example.com | TXT | TLS reporting |
| autoconfig.example.com | CNAME/A | Optional client discovery |

Never point MX directly at a CNAME. Keep the MX target stable and certificate-covered.

## TTL strategy

At least 48 hours before cutover, reduce only the records that must change. Record original TTLs and restore them after stabilization. Low TTL does not flush resolver caches already holding older data.

## Network controls

- Permit public inbound TCP 25.
- Permit user networks to 587, 993, and 443.
- Expose 465 only if the service owner requires implicit TLS submission.
- Restrict SSH to a management path.
- Deny public access to 24, 110, 143, 4190, 3306, 6379, Rspamd controller ports, and local metrics.
- Allow outbound DNS, NTP, HTTPS for updates/ACME, and SMTP as required.

## Reputation checks

Before cutover, verify the address is not listed because of a prior tenant, the ASN permits mail hosting, forward-confirmed reverse DNS works, and abuse/security contacts are monitored. New addresses should begin with low, legitimate volume.

## Validation

~~~bash
./scripts/check-mail-dns.sh example.com mail.example.com 192.0.2.10 mail
~~~

Review all warnings manually. DNS publication alone does not prove propagation or provider acceptance.
