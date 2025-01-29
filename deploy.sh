#!/usr/bin/env bash

set -euo pipefail

# copy files from branch main
copy_file_from_main() {
  git checkout main -- .gitignore .gitlab-ci.yml README.md icons.sh deploy.sh config.toml data/friendlinks.yml data/headers.yml
}

# update nav url
update_nav_url() {
  # update config.toml
  sed -i 's#爱开发导航#爱开发全量导航#g' config.toml
  sed -i 's#nav.idev.top#navs.idev.top#g' config.toml

  # update data/headers.yml
  sed -i 's#全量#精选#g' data/headers.yml
  sed -i 's#navs.idev.top#nav.idev.top#g' data/headers.yml
}

PUBLISH_DIR="$(grep publishDir config.toml | awk -F '\"' '{print $2}')" # static files

if [ -z "$PUBLISH_DIR" ]; then
  echo "Not found publishDir in config.toml"
  exit 1
fi

# get branch name
GIT_BRANCH_NAME="$CI_COMMIT_BRANCH"

if [ "$GIT_BRANCH_NAME" = "main" ]; then   # 精选
  PROJECT_NAME="nav"
elif [ "$GIT_BRANCH_NAME" = "more" ]; then # 全量
  PROJECT_NAME="navs"
  BRANCH_NAME="main"

  copy_file_from_main

  update_nav_url
else
  echo -e "\033[31merror: git branch name is not correct.\033[m"
  exit 1
fi

# remove hugo old data
rm -rf "$PUBLISH_DIR"

# git push
if [ $# -ge 1 ]; then
  # hugo gen data
  hugo --minify

  if [ "${1:-}" == "yes" ]; then
    # publish
    echo -e "no\n" | wrangler pages deploy "$PUBLISH_DIR" \
      --project-name "$PROJECT_NAME" \
      --branch "$BRANCH_NAME"
  else
    # commit
    git add .
    git commit -am "feat: ${1}"
    git push origin "$BRANCH_NAME"
  fi
fi
