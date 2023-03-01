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

[[ "${BRANCH_NAME}" = "main" ]] || PROJECT_NAME="navmore"

# publish
HTTP_PROXY=http://localhost:${PORT} wrangler pages publish public --project-name "${PROJECT_NAME}"

# git push
if [ $# -ge 1 ]; then
  git add .
  git commit -am "feat: ${1}"
  git push origin "${BRANCH_NAME}"
fi
