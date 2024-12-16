#!/bin/bash

# 每次启动时的用户自定义操作
if [ -f /usr/local/bin/user-customer.sh ]; then
    chmod +x /usr/local/bin/user-customer.sh
    /usr/local/bin/user-customer.sh
fi

cat <<EOF >> /root/.bashrc
if [ -f /usr/local/bin/user-bashrc ]; then
    chmod +x /usr/local/bin/user-bashrc
    source /usr/local/bin/user-bashrc
fi
EOF

while true; do
    sleep 60
done
