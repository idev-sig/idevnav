#!/usr/bin/env bash

##
# 从 icon 抓取图标
##

set -e

ICON_PATH="static/assets/images/logos"
[ -d "$ICON_PATH" ] || mkdir -p $ICON_PATH

# [ $# -eq 0 ] || rm -rf icons/*

while IFS= read -r _V; do
  # 提取文件名
  prefix="https://api.iowen.cn"
  if [[ "$_V" == "$prefix"* ]]; then

    # 从文件名获取图标
    FILENAME=${_V##*/}
    if [[ "$FILENAME" == "logo."* ]]; then
      FILENAME=""
    fi

    if [[ -z "$FILENAME" ]]; then
      FILENAME=$(echo "$_V" | awk -F'/' '{print $5}' | awk -F. '{print $(NF-1)}')
      # 处理 .com.cn | .net.cn | .org.cn
      if [ "$FILENAME" == "com" ] || [ "$FILENAME" == "org" ] || [ "$FILENAME" == "net" ]; then
        FILENAME=$(echo "$_V" | awk -F'/' '{print $5}' | awk -F. '{print $(NF-2)}')
      fi
    fi
    CLEANED_NAME=$(echo "$FILENAME" | sed -e 's/www\.//' -e 's/\.com//' -e 's/\./_/g')
    CLEANED_NAME="${CLEANED_NAME%_*}.png"
  else
    DOMAIN=$(echo "$_V" | sed -E 's~https?://([^/]+)/.*~\1~')
    CLEANED_NAME="${DOMAIN%.*}.${_V##*.}"
  fi

  # LOGO 路径
  FILEPATH="$ICON_PATH/$CLEANED_NAME"
  echo "$FILEPATH"

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
