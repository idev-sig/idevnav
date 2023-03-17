#!/usr/bin/env bash

set -e
set -u

# hugo build
hugo -D

# set port
PORT="20171"
[ $# -ge 2 ] && PORT="${2}"

BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

PROJECT_NAME="nav"
PUB_BARNCH_NAME="main"
PUBLISH_DIR="docs"

if [[ "$BRANCH_NAME" != "$PUB_BARNCH_NAME" ]]; then
  # PUB_BARNCH_NAME="dev"
  PROJECT_NAME="navmore"
fi

[ -d "icons" ] && cp icons/* docs/assets/images/logos/

# publish
HTTP_PROXY=http://localhost:$PORT wrangler pages publish "$PUBLISH_DIR" --project-name "$PROJECT_NAME" --branch "$PUB_BARNCH_NAME"

# git push
if [ $# -ge 1 ]; then
  git add .
  git commit -am "feat: ${1}"
  git push origin "${BRANCH_NAME}"
fi
