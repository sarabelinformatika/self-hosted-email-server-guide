# Cutover runbook

## Preconditions

- [ ] Change approved and bridge opened.
- [ ] Backups and isolated restore verified.
- [ ] DNS old/new values and rollback recorded.
- [ ] Source and target inventories reconciled.
- [ ] External SMTP, IMAPS, submission, HTTPS, and TLS tests passed.
- [ ] Support and business communications ready.

## Timeline

| UTC | Owner | Action | Validation | Rollback trigger |
|---|---|---|---|---|
| | | Freeze changes | | |
| | | Final delta sync | | |
| | | Change MX/sender records | | |
| | | Validate two-way mail | | |
| | | Observe queues and auth | | |

## Decision

- Go/no-go time:
- Decision owner:
- Result:
- Rollback actions, if any:
- Handover time and owner:
