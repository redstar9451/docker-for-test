#!/bin/bash

# 如果挂载了 gitconfig 文件，则复制到用户目录
if [ -f /mnt/gitconfig ]; then
    cp /mnt/gitconfig /root/.gitconfig
fi

# 其他初始化操作

while true; do
    sleep 60
done
