<p align="center">
  <picture><source media="(prefers-color-scheme: dark)" srcset="https://global.media.stuxedo.com/logo-light.png"><source media="(prefers-color-scheme: light)" srcset="https://global.media.stuxedo.com/logo-dark.png"><img src="https://global.media.stuxedo.com/logo-dark.png" height="80" alt="Stuxedo Logo"></picture>
</p>

# Contributing to Stuxedo Status

Thanks for your interest in contributing! This is a small static landing page, so contributions
are usually small too.

## Getting started

1. **Fork the repository** and clone your fork locally.
2. **Run it locally** with `./dev-server.sh` (or `dev-server.bat` on Windows) and open the printed URL. Add `--lan` to open it from a phone or another device on your network: it listens on every interface instead of `127.0.0.1` only and prints the addresses to open (usually the `192.168.x.x` one).
3. **Make your changes**. There's no build step.
4. **Open a pull request** against `main` with a clear description of what changed and why.

## Style guidelines

- Keep `index.html` a single static HTML file: no build tooling, no frameworks.
- Match the existing CSS variables and the light/dark theme structure, and test both themes and a
  phone-width window.
- The buttons' badge icons are generated: edit `scripts/badge-icons.py` and rerun it rather than
  editing the PNGs.
- The sitemap (`sitemap.xml`, `sitemap/index.html`, `robots.txt`) is generated: after adding or
  removing a page, edit `PAGES` in `scripts/build-sitemap.py` and run `python scripts/build-sitemap.py`.
- General contact uses `hello@stuxedo.com`; legal-page contact uses `legal@stuxedo.com`.

## Branches and going live

- **`main` is what's live.** Nothing is pushed to it directly: it only changes when a pull request from `staging` is merged. Merging into it deploys the site to GitHub Pages.
- **`staging` is the last check before live.** It only changes when a pull request from `test` is merged. It needs CI to pass. Nothing deploys from it.
- **Work happens on `test`**, or on a feature branch off `test` that's merged back into it. Releases are made on `test` too; `commit.sh` / `commit.bat` refuse to run on `staging` or `main`.
- **Going live:** push `test` with its tag, open a pull request into staging (`gh pr create --base staging --head test`), check staging once it's merged, then open one from staging into main (`gh pr create --base main --head staging`). Leo reviews and merges both.

## Versioning

Since v26.11.07, its first stable release, this project uses [Date Versioning](https://datevers.ing):
the UTC release date as `YY.MM.DD`, with `-1`, `-2`… for later releases the same day. Earlier releases
(`v0.x.y`) used [Semantic Versioning](https://semver.org); it never goes back to them, and there is no 1.0.0.

To release:

1. Add a `## vX` entry at the top of `CHANGELOG.md`, with its sections in this order: Added, Changed,
   Fixed, Removed, Security, Deprecated.
2. Set `VERSION.md` to the same bare version (no `v`).
3. Run `bash tests/version.sh` and `bash tests/site.sh`.
4. Run `./commit.sh` (or `commit.bat` on Windows). It checks the version, commits, tags `vX`, and
   never pushes.

## Questions

Reach out at [hello@stuxedo.com](mailto:hello@stuxedo.com) or open a discussion in this repository.

---

*Stuxedo is part of the [Stux.Group](https://github.com/StuxGroup) Brand of Companies.*
