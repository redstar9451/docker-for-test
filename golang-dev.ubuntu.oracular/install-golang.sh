#!/bin/bash

# run different command based on architecture
cd "/root" || { echo "Failed to cd to /root"; exit 1; }
if [ "$(uname -m)" == "x86_64" ]; then
    wget https://go.dev/dl/go1.17.13.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.17.13.linux-amd64.tar.gz
else
    wget https://go.dev/dl/go1.17.13.linux-arm64.tar.gz
    tar -C /usr/local -xzf go1.17.13.linux-arm64.tar.gz
fi

cat <<EOF >> /root/.bashrc
#golang config
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

# Set environment variables directly in the script
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

mkdir -p /data/go
# v1.8.3 is the latest version support go1.17
go install github.com/go-delve/delve/cmd/dlv@v1.8.3
# https://github.com/golang/tools/tree/master/gopls, v0.11.0 is the latest version support go1.17
go install golang.org/x/tools/gopls@v0.11.0

cd "/root" || { echo "Failed to cd to /root"; exit 1; }
if [ "$(uname -m)" == "x86_64" ]; then
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_arm64.tar.gz
else
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_amd64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_amd64.tar.gz
fi
echo 'eval "$(fzf --bash)"' >> /root/.bashrc
