#!/bin/bash
# run different command based on architecture

if [ "$(uname -m)" == "aarch64" ]; then
    # libfaketime
    sed -i 's/int gettimeofday(struct timeval \*tv, void \*tz)/int gettimeofday(struct timeval \*tv, struct timezone \*tz)/' /root/libfaketime-0.9.10/src/libfaketime.c

    # set locale
    yum install -y glibc-langpack-en
    localedef -i en_US -f UTF-8 en_US.UTF-8
fi


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

mkdir -p /data/go
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
# this is support for go1.17
go get github.com/go-delve/delve/cmd/dlv@v1.8.3
# https://github.com/golang/tools/tree/master/gopls, Supported Go versions
go install golang.org/x/tools/gopls@v0.11.0
