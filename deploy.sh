#!/usr/bin/env bash

set -euo pipefail

# 处理参数信息
judgment_parameters() {
    while [[ "$#" -gt '0' ]]; do
        case "$1" in
            '-d' | '--deploy') # 部署
                DEPLOY="true"
                ;;
            '-p' | '--publish') # 部署目录
                shift
                PUBLISH_DIR="${1:?"error: Please specify the correct publish directory."}"
                ;;
            '-g' | '--git')
                shift
                COMMIT_MSG="${1:?"error: Please specify the correct commit message."}"
                ;;
            '-h' | '--help')
                show_help
                ;;
            *)
                echo "$0: unknown option -- $1" >&2
                exit 1
                ;;
        esac
        shift
    done
}

# 显示帮助信息
show_help() {
    cat <<EOF
usage: $0 [ options ]

  -h, --help                           print help
  -d, --deploy                         deploy
  -p, --publish <publish>              set publish directory
  -g, --git <git>                      set commit message
EOF
    exit 0
}

# 获取发布目录
get_publish_dir() {
  PUBLISH_DIR="$(grep publishDir config.toml | awk -F '\"' '{print $2}')" # static files
}

# 获取项目名称
get_project_name() {
  if [ "$GIT_BRANCH_NAME" = "main" ]; then   # 精选
    PROJECT_NAME="nav"
  elif [ "$GIT_BRANCH_NAME" = "more" ]; then # 全量 
    PROJECT_NAME="navs"
  fi 
}

# more 分支处理
action_for_more_bracnch() {
  # 拉取 main 分支文件
  git checkout main -- .gitignore .gitlab-ci.yml README.md icons.sh deploy.sh config.toml data/friendlinks.yml data/headers.yml

  # update config.toml
  sed -i 's#精选导航#全量导航#g' config.toml
  sed -i 's#nav.idev.top#navs.idev.top#g' config.toml

  # update data/headers.yml
  sed -i 's#全量#精选#g' data/headers.yml
  sed -i 's#navs.idev.top#nav.idev.top#g' data/headers.yml    
}

# 检测参数是否正确
check_parameters() {
  if [ -z "${PUBLISH_DIR:-}" ]; then
    echo "error: publish directory cannot be empty."
    exit 1
  fi
}

# git push
git_commit_and_push() {
  if [ -z "${COMMIT_MSG:-}" ]; then
    git add .
    git commit -am "feat: $COMMIT_MSG"
    git push origin "$GIT_BRANCH_NAME"  
  fi
}

# 部署到 Cloudflare
deploy_to_cloudflare() {
  if [ -n "${PROJECT_NAME:-}" ]; then
    echo -e "no\n" | wrangler pages deploy "$PUBLISH_DIR" \
      --project-name "$PROJECT_NAME" \
      --branch main  
  fi
}

COMMIT_MSG="" # 提交信息
PUBLISH_DIR=""  # 发布目录
PROJECT_NAME="" # 项目名称
GIT_BRANCH_NAME="${CI_COMMIT_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}" # 分支名称

DEPLOY=""      # 部署

main() {
  get_publish_dir
  get_project_name

  judgment_parameters "$@"

  check_parameters

  if [ "$GIT_BRANCH_NAME" = "more" ]; then
    action_for_more_bracnch
  fi

  # remove hugo old data
  rm -rf "$PUBLISH_DIR"  

  echo
  echo "DEPLOY: $DEPLOY"
  echo "PUBLISH_DIR: $PUBLISH_DIR"
  echo "PROJECT_NAME: $PROJECT_NAME"
  echo "COMMIT_MSG: $COMMIT_MSG"
  echo "GIT_BRANCH_NAME: $GIT_BRANCH_NAME"
  echo

  # hugo gen data
  hugo --minify

  if [ ! -d "$PUBLISH_DIR" ]; then
      echo -e "\033[31mpublishDir $PUBLISH_DIR not found\033[0m"
      exit 1
  fi    

  git_commit_and_push

  deploy_to_cloudflare
}

main "$@"
