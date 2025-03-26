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

    # v1.22.1 is the latest version support go1.19
    DLV_VERSION="v1.22.1"
    # https://github.com/golang/tools/tree/master/gopls
    GOLSP_VERSION="v0.15.3"
elif [ "$GO_VERSION" == "1.22" ]; then
    echo "Installing Go version 1.22"
    ARM_GO="https://go.dev/dl/go1.22.0.linux-arm64.tar.gz"
    X86_GO="https://go.dev/dl/go1.22.0.linux-amd64.tar.gz"

    # v1.22.1 is the latest version support go1.22
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
# I did not test these commands for go1.17
go install golang.org/x/tools/cmd/goimports@v0.5.0
go install honnef.co/go/tools/cmd/staticcheck@v0.4.7
go install github.com/fatih/gomodifytags@v1.17.0
go install github.com/haya14busa/goplay/cmd/goplay@latest
go install github.com/josharian/impl@latest
go install github.com/cweill/gotests/gotests@latest

# go:	/usr/local/go/bin/go: go version go1.22.0 linux/arm64
# gopls:	/data/go/bin/gopls	(version: v0.15.3 built with go: go1.22.0)
# gotests:	/data/go/bin/gotests	(version: v1.6.0 built with go: go1.22.0)
# gomodifytags:	/data/go/bin/gomodifytags	(version: v1.17.0 built with go: go1.22.0)
# impl:	/data/go/bin/impl	(version: v1.4.0 built with go: go1.22.0)
# goplay:	/data/go/bin/goplay	(version: v1.0.0 built with go: go1.22.0)
# dlv:	/data/go/bin/dlv	(version: v1.22.1 built with go: go1.22.0)
# staticcheck:	/data/go/bin/staticcheck	(version: v0.4.7 built with go: go1.22.0)

cd "/root" || { echo "Failed to cd to /root"; exit 1; }
if [ "$(uname -m)" == "x86_64" ]; then
     wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_amd64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_amd64.tar.gz
else
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_arm64.tar.gz
fi
echo 'eval "$(fzf --bash)"' >> /root/.bashrc
