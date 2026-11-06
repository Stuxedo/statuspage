#!/usr/bin/env bash
# Checks VERSION.md: a 0.x.y Semantic Version before the first stable release, or a Date Version
# (https://datevers.ing, the UTC release date as YY.MM.DD plus -1, -2... for later releases the
# same day) from it on; never 1.0.0, and never 0.x.y once a Date Version is tagged. It must also
# match the newest release in CHANGELOG.md.
# Run with: bash tests/version.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PASS=0
FAIL=0
check() { # check "description" command...
    local name="$1"; shift
    if "$@"; then PASS=$((PASS + 1)); echo "ok   - $name"; else FAIL=$((FAIL + 1)); echo "FAIL - $name"; fi
}

SEMVER='^0\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
DATEVER='^[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])(-[1-9][0-9]*)?$'
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION.md")"

is_valid()      { [[ "$VERSION" =~ $SEMVER || "$VERSION" =~ $DATEVER ]]; }
has_datever()   { git -C "$ROOT" tag -l 'v[0-9][0-9].[0-9][0-9].[0-9][0-9]*' 2>/dev/null | grep -q .; }
no_regression() { ! [[ "$VERSION" =~ $SEMVER ]] || ! has_datever; }
is_real_date() {
    [[ "$VERSION" =~ $DATEVER ]] || return 0
    local d="${VERSION%%-*}"
    [ "$(date -u -d "20${d//./-}" +%y.%m.%d 2>/dev/null)" = "$d" ]
}
not_future() {
    [[ "$VERSION" =~ $DATEVER ]] || return 0
    local d="${VERSION%%-*}"
    ! [[ "$d" > "$(date -u +%y.%m.%d)" ]]
}
changelog_matches() {
    local newest
    newest="$(grep -m1 -oE '^## v[^ ]+' "$ROOT/CHANGELOG.md" | sed 's/^## v//')"
    [ "$newest" = "$VERSION" ]
}

check "VERSION.md ($VERSION) is a 0.x.y version or a Date Version (YY.MM.DD or YY.MM.DD-N)" is_valid
check "VERSION.md ($VERSION) doesn't go back to 0.x.y after a Date Version" no_regression
check "VERSION.md ($VERSION) is a real calendar date (Date Versions only)" is_real_date
check "VERSION.md ($VERSION) isn't dated in the future (UTC)" not_future
check "the newest '## v...' heading in CHANGELOG.md is VERSION.md" changelog_matches

echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
