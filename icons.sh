#!/usr/bin/env bash

##
# 从 icon 抓取图标
##

set -e

ICON_PATH="static/assets/images/logos"
[ -d "$ICON_PATH" ] || mkdir -p $ICON_PATH

# [ $# -eq 0 ] || rm -rf icons/*

# sync images
SYNC_FILE=".sync.txt"
SYNC_FOLDER="static/assets/images/logos"
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH_NAME" == "more" ]]; then
  while IFS= read -r _IMAGE; do
    # IMAGE_PATH="$SYNC_FOLDER/$_IMAGE"
    # IMAGE_PATH="$_IMAGE"
    # if [[ -f "$IMAGE_PATH" ]]; then
    #   echo "sync main: $IMAGE_PATH"
    #   git checkout main -- "$IMAGE_PATH"
    # fi
    IMAGE_PATH="$_IMAGE"
    echo "sync main: $IMAGE_PATH"
    git checkout main -- "$IMAGE_PATH"
  done < <(tail -n+2 $SYNC_FILE)
elif [[ "$BRANCH_NAME" == "main" ]]; then
  echo "# sync logos images" >$SYNC_FILE
  while IFS= read -r _IMAGE; do
    IMAGE_NAME=${_IMAGE##*/}
    IMAGE_PATH="$SYNC_FOLDER/$IMAGE_NAME"
    if [[ -f "$IMAGE_PATH" ]]; then
      echo "write to .sync.txt: $IMAGE_NAME"
      echo "$IMAGE_PATH" >>$SYNC_FILE
    fi
  done < <(git status | grep logos)
fi

# fetch images
while IFS= read -r _V; do
  # 获取 # 符号前的数据
  ICON_URL=$(echo "$_V" | awk -F '#' '{print $1}')

  # 获取 # 符号后的数据
  FILENAME=$(echo "$_V" | awk -F '#' '{print $2}')

  if [[ -n "$FILENAME" ]]; then
    CLEANED_NAME="$FILENAME"
  else
    # 提取文件名
    prefix="https://api.iowen.cn"
    if [[ "$ICON_URL" == "$prefix"* ]]; then
      FILENAME=$(echo "$ICON_URL" | awk -F'/' '{print $5}' | awk -F. '{print $(NF-1)}')
      # 处理 .com.cn | .net.cn | .org.cn
      if [[ ${#FILENAME} -eq 3 ]]; then
        FILENAME=$(echo "$ICON_URL" | awk -F'/' '{print $5}' | awk -F. '{print $(NF-2)}')
      fi
      # 处理 cn 或其它如 cc 等国别域名
      if [[ ${#FILENAME} -eq 2 ]]; then
        FILENAME=$(echo "$ICON_URL" | awk -F'/' '{print $5}' | sed 's#www.##' |
          sed 's#.com##' | sed 's#.net##' | sed 's#.org##' | sed "s#.${FILENAME}##")
      fi
    fi

    # 自定义文件名不存在则从 URL 中取
    [[ -n "$FILENAME" ]] || FILENAME="${ICON_URL##*/}"
    # echo "FILENAME: $FILENAME"

    # 从文件名获取图标
    [[ "$FILENAME" != "logo."* ]] || FILENAME=""

    CLEANED_NAME=$(echo "$FILENAME" | sed -e 's/www\.//' -e 's/\.com//' -e 's/\./_/g')
    CLEANED_NAME="${CLEANED_NAME%_*}.png"
  fi

  # echo "CLEANED_NAME: $CLEANED_NAME"
  # continue

  # LOGO 路径
  FILEPATH="$ICON_PATH/$CLEANED_NAME"

  # 下载 LOGO
  if [ ! -f "$FILEPATH" ]; then
    printf "fetch logo: %s to %s\n" "$_V" "$CLEANED_NAME"
    curl -fsL -o "$FILEPATH" "$_V" || exit 1
  fi

  # 替换 LOGO
  if [ -f "$FILEPATH" ]; then
    sed -i "s@$_V@$CLEANED_NAME@" ./data/webstack.yml
  fi
done < <(grep "logo: http" ./data/webstack.yml | awk '{print $2}')
