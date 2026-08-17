# Contributing

Contributions that improve accuracy, safety, portability, and recovery readiness are welcome.

## Expectations

1. Open an issue for architectural or scope changes.
2. Use synthetic domains, addresses, message IDs, and logs.
3. Keep scripts read-only unless the change is explicitly approved as a separate automation tool.
4. Explain version assumptions and link primary upstream documentation.
5. Include validation and rollback guidance with configuration examples.
6. Run shell syntax checks and Markdown link checks before submitting.

Never commit credentials, TLS private keys, DKIM private keys, mailbox data, public IP allocations, or customer records.

## Documentation style

- Write in clear technical English.
- State prerequisites, change risk, validation, rollback, and evidence.
- Distinguish required controls from optional enhancements.
- Prefer placeholders such as mail.example.com and 192.0.2.10.
- Avoid claiming that a single DNS record or product guarantees delivery.
