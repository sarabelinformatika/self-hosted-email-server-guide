# 08 — TLS and certificate lifecycle

## Service names

Issue a publicly trusted certificate containing every public service hostname that clients are expected to validate, typically mail.example.com and webmail.example.com. The MTA-STS endpoint may use a separate certificate.

## Protocol policy

- Internet SMTP on port 25 normally uses opportunistic TLS; mandatory TLS for all destinations breaks delivery to incompatible MTAs.
- Submission on 587 requires STARTTLS before authentication.
- IMAPS on 993 and HTTPS on 443 require valid certificates.
- Disable obsolete SSL/TLS versions according to the capabilities of the installed packages and supported clients.

## Private-key controls

Generate keys on the service or approved key-management host. Restrict ownership and mode. Do not copy a combined key bundle into locations readable by webmail or unrelated services. Record renewal and deploy hooks without logging key material.

## Renewal design

Certificate automation is mandatory. Test:

1. issuance and renewal in staging where supported;
2. atomic file replacement;
3. Postfix, Dovecot, and Nginx reload hooks;
4. post-renewal handshake on 25, 587, 993, and 443;
5. alerting well before expiry;
6. recovery when the ACME account, DNS API, or HTTP challenge fails.

Shorter certificate lifetimes make manual renewal unsafe. Monitor automation outcomes, not only current expiry.

## MTA-STS and TLS-RPT

MTA-STS tells supporting senders which MX identities are valid and whether verified TLS is required. Publish the HTTPS policy in testing mode first, inspect TLS reports, then move to enforce only when every active MX has a valid certificate and stable name.

TLS-RPT is delayed aggregate telemetry, not a real-time alert. Route reports to a monitored processor and protect report data according to policy.

## Validation

~~~bash
./scripts/verify-mail-tls.sh mail.example.com
openssl x509 -in /path/to/fullchain.pem -noout -subject -issuer -dates -ext subjectAltName
~~~

Test from outside the server network. A local handshake does not validate public routing, NAT, or resolver behavior.
