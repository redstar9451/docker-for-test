#!/bin/bash

# https://go.dev/dl/
if [ "$GO_VERSION" == "1.17" ]; then
    echo "Installing Go version 1.17"
    ARM_GO="https://go.dev/dl/go1.17.13.linux-arm64.tar.gz"
    X86_GO="https://go.dev/dl/go1.17.13.linux-amd64.tar.gz"

    # v1.8.3 is the latest version support go1.17
    DLV_VERSION="v1.8.3"
    # https://github.com/golang/tools/tree/master/gopls, v0.11.0 is the latest version support go1.17
    GOLSP_VERSION="v0.11.0"
elif [ "$GO_VERSION" == "1.19" ]; then
    echo "Installing Go version 1.19"
    ARM_GO="https://go.dev/dl/go1.19.13.linux-arm64.tar.gz"
    X86_GO="https://go.dev/dl/go1.19.13.linux-amd64.tar.gz"

    # v1.8.3 is the latest version support go1.19
    DLV_VERSION="v1.22.1"
    # https://github.com/golang/tools/tree/master/gopls
    GOLSP_VERSION="v0.15.3"
else
    echo "Unsupported Go version: $GO_VERSION"
    exit 1
fi

# run different command based on architecture
cd "/root" || { echo "Failed to cd to /root"; exit 1; }
if [ "$(uname -m)" == "x86_64" ]; then
    wget "$X86_GO"
    tar -C /usr/local -xzf "$(basename "$X86_GO")"
else
    wget "$ARM_GO"
    tar -C /usr/local -xzf "$(basename "$ARM_GO")"
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
go install github.com/go-delve/delve/cmd/dlv@"$DLV_VERSION"

go install golang.org/x/tools/gopls@"$GOLSP_VERSION"


cd "/root" || { echo "Failed to cd to /root"; exit 1; }
if [ "$(uname -m)" == "x86_64" ]; then
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_arm64.tar.gz
else
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_amd64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_amd64.tar.gz
fi
echo 'eval "$(fzf --bash)"' >> /root/.bashrc
