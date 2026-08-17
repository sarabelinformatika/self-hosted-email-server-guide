# 11 — Roundcube webmail

## Role

Roundcube is a browser client for Dovecot IMAP and Postfix submission. It must not access mailbox storage, Postfix maps, or mail signing keys directly.

## Installation boundary

Install a stable release or supported distribution package. Roundcube 1.7 and later uses public_html as the intended document root. Do not expose the repository root, config, logs, temp, vendor tooling, or installer.

After setup:

- remove or disable the installer;
- use a dedicated least-privilege database identity;
- set a unique random des_key through a protected secret mechanism;
- enforce HTTPS and secure cookie settings;
- restrict plugins to reviewed, maintained components;
- configure SMTP submission with the authenticated user identity;
- configure IMAPS with certificate verification;
- set upload and attachment limits consistently across Nginx, PHP, Roundcube, Postfix, and Rspamd.

## Reverse proxy

Set security headers deliberately and test compatibility. Preserve the actual client address only through trusted proxy hops. Do not trust arbitrary X-Forwarded-For headers.

## Session and account security

Use short idle timeouts appropriate to the environment, protect session storage, rate-limit login attempts, and avoid browser password storage on shared devices. Roundcube does not add MFA to SMTP/IMAP by itself; integrate an appropriate identity proxy or choose a platform that meets the requirement.

## Upgrade

Back up the database and configuration, review upstream release notes, test plugins and PHP compatibility, run schema migration, validate login/send/receive/address book, and keep an application rollback artifact.

## Acceptance

From an external browser verify valid TLS, no installer access, authenticated IMAP, SMTP submission, attachment limits, logout/session invalidation, and absence of sensitive paths in HTTP responses.
