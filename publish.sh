#!/usr/bin/env bash

set -e
set -u

# hugo build
hugo -D

# set port
PORT="20171"
[ $# -ge 2 ] && PORT="${2}"

# publish
HTTP_PROXY=http://localhost:${PORT} wrangler pages publish docs --project-name nav

# git push
if [ $# -ge 1 ]; then
  git add .
  git commit -am "feat: ${1}"
  git push origin main
fi
