#!/usr/bin/env bash

set -e
set -u

# hugo build
hugo -D

PORT="20171"
[ $# -ge 2 ] && PORT="${2}"

HTTP_PROXY=http://localhost:${PORT} wrangler pages publish docs

# git push
git add .
git commit -am "${1}"
git push origin main
