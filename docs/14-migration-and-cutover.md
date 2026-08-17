# 14 — Migration and cutover

## Migration principles

Separate identity provisioning, historical mailbox synchronization, DNS change, live mail routing, and client transition. Each has an independent validation and rollback decision.

## Preparation

- Inventory domains, aliases, shared mailboxes, forwarding, groups, quotas, Sieve/rules, applications, and devices.
- Remove obsolete objects before migration.
- Lower relevant DNS TTLs in advance.
- Pre-stage mailboxes and perform an initial IMAP synchronization.
- Validate password strategy; never export hashes unless formats and authorization permit it.
- Establish coexistence routing if the source and target will both receive mail.
- Communicate client settings, outage expectations, and support channels.

## Cutover sequence

1. Freeze or record identity changes.
2. Run delta synchronization.
3. Validate target services and external probes.
4. Change MX and related sender records according to the approved DNS record.
5. Keep the source receiving/forwarding during the coexistence window.
6. Run another delta sync.
7. Validate two-way delivery, replies, aliases, applications, mobile clients, and webmail.
8. Monitor queue, logs, DMARC, TLS, and helpdesk events.

## Rollback triggers

Examples include unknown-recipient failures above threshold, widespread authentication failure, queue age beyond the agreed limit, certificate/name mismatch, data reconciliation failure, or confirmed unauthorized relay.

Rollback must specify DNS restoration, routing, source acceptance, data delta ownership, user communication, and evidence preservation. DNS rollback is not instantaneous.

## Acceptance

Reconcile object counts and sampled message folders, obtain service/security/business sign-off, restore normal TTLs, retain the source read-only for the approved period, and schedule decommissioning.
