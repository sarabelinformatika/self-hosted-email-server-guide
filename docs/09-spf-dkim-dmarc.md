# 09 — SPF, DKIM, and DMARC

These controls authenticate domains and authorize infrastructure. They do not scan content and do not guarantee inbox placement.

## SPF

Publish one SPF TXT record per organizational domain. Authorize only actual outbound paths and keep DNS lookup limits in mind. End with a deliberate qualifier; use a staged policy while discovering senders.

~~~text
example.com.  TXT  "v=spf1 ip4:192.0.2.10 -all"
~~~

SPF evaluates the envelope domain and can break through forwarding. Do not add broad provider ranges without an inventory.

## DKIM

Generate keys on the signing system, keep the private key readable only by Rspamd, and publish the public key under a selector:

~~~text
mail._domainkey.example.com. TXT "v=DKIM1; k=rsa; p=<PUBLIC_KEY>"
~~~

Use a selector naming convention that supports rotation. Publish the new selector before signing with it; retain the old public key until delayed mail and retry windows have expired.

## DMARC

Start with reporting and strict data handling:

~~~text
_dmarc.example.com. TXT "v=DMARC1; p=none; rua=mailto:dmarc@example.com; adkim=r; aspf=r; pct=100"
~~~

Inventory all legitimate senders, resolve alignment failures, then progress to quarantine and reject. Protect the report mailbox and prefer a parser that minimizes sensitive data exposure.

## Alignment

DMARC passes when the visible From domain aligns with a passing SPF or DKIM domain. DKIM alignment is usually more resilient to forwarding. Ensure mailing lists, ticketing tools, scanners, and applications are included in testing.

## Change sequence

1. Inventory and classify every sender.
2. Publish SPF and DKIM.
3. Validate signatures and alignment.
4. Publish DMARC p=none and analyze reports.
5. Correct or retire unauthorized sources.
6. Increase enforcement in measured stages.
7. Monitor continuously after p=reject.

## Acceptance

Test internal-to-external and external-to-internal messages through at least two independent receivers. Inspect Authentication-Results headers without sharing real messages publicly.
