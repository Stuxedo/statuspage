# Changelog

All notable changes to Stuxedo Status (status.stuxedo.com) are documented here. Each release's
sections follow a fixed order: Added, Changed, Fixed, Removed, Security, Deprecated.

This project is pre-stable, so it uses [Semantic Versioning](https://semver.org) on `0.x.y`. Its
first stable release will be its first [Date Version](https://datevers.ing) (`YY.MM.DD`, the UTC
release date), with no 1.0.0.

## v0.1.0

### Added

- **The Stuxedo Status landing page** for `status.stuxedo.com`: "Which status would you like to
  check?" with two big buttons. **Stuxedo Web Status** (`status.stuxedo.dev`) covers websites, email
  and web hosting. **Stuxedo Server Status** (`status.stuxedo.net`) covers the servers behind every
  region, and shows their overall status live from its published summary.
- Badge icons for both, built by `scripts/badge-icons.py` in Stuxedo's colours: a browser window for
  Web Status and a heartbeat for Server Status (the same icon status.stuxedo.net uses).
- Light and dark themes, the changelog page, the Boring Legal Stuff hub with its six pages, a
  sitemap, a 404 page, and a local dev server (`dev-server.sh` / `dev-server.bat`).
