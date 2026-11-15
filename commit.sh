#!/bin/bash
# Stuxedo Status - Git commit + tag script
# Commits whatever's staged/unstaged and tags it with the version currently
# in VERSION.md, read dynamically so this script never goes stale the way a
# hardcoded version number does.
#
# Versioning has two stages:
#   - Before the first stable release: Semantic Versioning (https://semver.org) on 0.x.y.
#   - The first stable release, and every release after it: Date Versioning
#     (https://datevers.ing), the UTC release date as YY.MM.DD, plus -1, -2... for
#     later releases the same day. There is no 1.0.0, and once a Date Version is
#     tagged the project never goes back to 0.x.y.
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"
VERSION="$(tr -d '[:space:]' < "$DIR/VERSION.md")"

# Releases are made on test (or a branch off it). staging and main only change through
# pull requests: test -> staging -> main.
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "staging" ]; then
    echo "You're on $BRANCH. Releases are made on test, then go test -> staging -> main through pull requests: git switch test" >&2
    exit 1
fi

SEMVER='^0\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$'
DATEVER='^[0-9]{2}\.(0[1-9]|1[0-2])\.(0[1-9]|[12][0-9]|3[01])(-[1-9][0-9]*)?$'

if [[ "$VERSION" =~ $SEMVER ]]; then
    if git tag -l 'v[0-9][0-9].[0-9][0-9].[0-9][0-9]*' | grep -q .; then
        echo "VERSION.md holds '$VERSION', but this project already has Date Version tags and never goes back to 0.x.y." >&2
        exit 1
    fi
elif [[ "$VERSION" =~ $DATEVER ]]; then
    DATE="${VERSION%%-*}"
    if ! date -u -d "20${DATE//./-}" >/dev/null 2>&1; then
        echo "VERSION.md holds '$VERSION', which isn't a real calendar date." >&2
        exit 1
    fi
    TODAY="$(date -u +%y.%m.%d)"
    if [[ "$DATE" > "$TODAY" ]]; then
        echo "VERSION.md is dated $DATE, after today ($TODAY UTC). Date Versions can't be in the future." >&2
        exit 1
    elif [[ "$DATE" < "$TODAY" ]]; then
        echo "Warning: VERSION.md is dated $DATE, but today is $TODAY (UTC). Releasing today? Use $TODAY." >&2
    fi
else
    echo "VERSION.md holds '$VERSION', which is neither a 0.x.y version nor a Date Version (YY.MM.DD or YY.MM.DD-N). There is no 1.0.0: the first stable release is the first Date Version." >&2
    exit 1
fi

git add -A
if ! git diff --cached --quiet; then
    git commit -m "$(cat <<MSG
Release v${VERSION}

See CHANGELOG.md for details.
MSG
)"
else
    echo "Nothing to commit - tagging the current HEAD as v${VERSION}."
fi

if git rev-parse -q --verify "refs/tags/v${VERSION}" >/dev/null; then
    echo "Tag v${VERSION} already exists - skipping."
else
    git tag -a "v${VERSION}" -m "Stuxedo Status v${VERSION}"
    echo "Tagged v${VERSION}."
fi

echo "Push with: git push origin $BRANCH v${VERSION}"
echo "Then open a pull request into staging: gh pr create --base staging --head $BRANCH"
echo "Once staging is checked, open one from staging into main: gh pr create --base main --head staging"
