#!/usr/bin/env bash

##
# 从 icon 抓取图标
##

set -e

[ -d icons ] || mkdir icons

# [ $# -eq 0 ] || rm -rf icons/*

while IFS= read -r _V; do
  # 提取文件名
  FILENAME=${_V##*/}
  CLEANED_NAME=$(echo "$FILENAME" | sed -e 's/www\.//' -e 's/\.com//' -e 's/\./_/g')
  CLEANED_NAME="${CLEANED_NAME%_*}.png"

  # LOGO 路径
  FILEPATH="icons/$CLEANED_NAME"

  # 下载 LOGO
  if [ ! -f "$FILEPATH" ]; then
    curl -fsL -o "$FILEPATH" "$_V" || exit 1
  fi

  # 替换 LOGO
  if [ -f "$FILEPATH" ]; then
    sed -i "s@$_V@$CLEANED_NAME@" ./data/webstack.yml
  fi
done < <(grep "logo: https" ./data/webstack.yml | awk '{print $2}')
