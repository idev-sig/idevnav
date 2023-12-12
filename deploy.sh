#!/usr/bin/env bash

set -e
set -u

# copy files from branch main
function copy_files() {
  git checkout main -- README.md icons.sh deploy.sh config.toml data/friendlinks.yml data/headers.yml

  # update config.toml
  sed -i 's#爱开发导航#爱开发全量导航#g' config.toml
  sed -i 's#nav.skiy.net#navs.skiy.net#g' config.toml

  # update data/headers.yml
  sed -i 's#全量#精选#g' data/headers.yml
  sed -i 's#navs.skiy.net#nav.skiy.net#g' data/headers.yml
}

PROJECT_NAME=""                                                         # nav or navs
PUBLISH_DIR="$(grep publishDir config.toml | awk -F '\"' '{print $2}')" # static files

if [[ -z "$PUBLISH_DIR" ]]; then
  echo "Not found publishDir in config.toml"
  exit 1
fi

# get branch name
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [[ "$BRANCH_NAME" == "main" ]]; then
  PROJECT_NAME="nav"
elif [[ "$BRANCH_NAME" == "more" ]]; then
  PROJECT_NAME="navs"
  BRANCH_NAME="main"
  copy_files
fi

if [[ -z "$PROJECT_NAME" ]]; then
  echo "error: branch name is not correct"
  exit 1
fi

# remove hugo old data
rm -rf "$PUBLISH_DIR"

# git push
if [[ $# -ge 1 ]]; then
  # hugo gen data
  hugo --minify

  if [[ "${1}" == "yes" ]]; then
    # publish
    wrangler pages deploy "$PUBLISH_DIR" \
      --project-name "$PROJECT_NAME" \
      --branch "$BRANCH_NAME"
  else
    # commit
    git add .
    git commit -am "feat: ${1}"
    git push origin "$BRANCH_NAME"
  fi
else
  # debug
  hugo server
fi
