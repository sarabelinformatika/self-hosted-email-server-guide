# DNS record reference

Replace all placeholders and obtain approval before publication.

~~~dns
example.com.                   3600 IN MX 10 mail.example.com.
mail.example.com.              3600 IN A 192.0.2.10

example.com.                   3600 IN TXT "v=spf1 ip4:192.0.2.10 -all"
mail._domainkey.example.com.   3600 IN TXT "v=DKIM1; k=rsa; p=<PUBLIC_KEY>"
_dmarc.example.com.            3600 IN TXT "v=DMARC1; p=none; rua=mailto:dmarc@example.com; adkim=r; aspf=r; pct=100"

_mta-sts.example.com.          3600 IN TXT "v=STSv1; id=2026081701"
mta-sts.example.com.           3600 IN A 192.0.2.20
_smtp._tls.example.com.        3600 IN TXT "v=TLSRPTv1; rua=mailto:tlsrpt@example.com"
~~~

The provider publishes PTR for 192.0.2.10 to mail.example.com. Do not publish the documentation address.

Example MTA-STS policy at https://mta-sts.example.com/.well-known/mta-sts.txt:

~~~text
version: STSv1
mode: testing
mx: mail.example.com
max_age: 86400
~~~

Move to enforce only after validating all MX hosts and reviewing reports. Increase max_age after the policy is stable.
