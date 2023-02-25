#!/usr/bin/env bash

set -e
set -u

# hugo build
hugo -D

# git push
git add .
git commit -am "feat: ${1}"
git push origin main

# set port
PORT="20171"
[ $# -ge 2 ] && PORT="${2}"

echo "${PORT}"
# publish
HTTP_PROXY=http://localhost:${PORT} wrangler pages publish docs --project-name nav
