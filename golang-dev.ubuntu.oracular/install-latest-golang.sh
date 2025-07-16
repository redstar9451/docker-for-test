#!/bin/bash

# Script to automatically install the latest Go version
# Usage: ./install-latest-golang.sh

set -e

echo "=== Go Latest Version Installer ==="

# Get latest version directly
echo "Fetching latest Go version from go.dev/dl/..."
LATEST_VERSION=$(curl -s https://go.dev/dl/ | grep -o 'go[0-9]\+\.[0-9]\+\.*[0-9]*\.linux-\(amd64\|arm64\)\.tar\.gz' | head -1 | sed 's/\.linux-\(amd64\|arm64\)\.tar\.gz//')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to detect latest version, using fallback: go1.22.0"
    LATEST_GO="go1.22.0"
else
    LATEST_GO="$LATEST_VERSION"
fi

echo "Latest Go version detected: $LATEST_GO"

# Determine architecture and download URL
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO}.linux-amd64.tar.gz"
    echo "Architecture: x86_64"
else
    DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO}.linux-arm64.tar.gz"
    echo "Architecture: $ARCH"
fi

echo "Download URL: $DOWNLOAD_URL"

# Create necessary directories
mkdir -p /data/go

# Download and install Go
cd /root || { echo "Failed to cd to /root"; exit 1; }
echo "Downloading Go..."
wget "$DOWNLOAD_URL"
echo "Extracting Go..."
tar -C /usr/local -xzf "$(basename "$DOWNLOAD_URL")"

# Set up environment variables
echo "Setting up environment variables..."
cat <<EOF >> /root/.bashrc
#golang config
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin
EOF

# Set environment variables for current session
export GOROOT=/usr/local/go
export GOPATH=/data/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Install Go tools
echo "Installing Go development tools..."
go install github.com/go-delve/delve/cmd/dlv@latest
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/haya14busa/goplay/cmd/goplay@latest
go install github.com/josharian/impl@latest
go install github.com/cweill/gotests/gotests@latest

# Install fzf
echo "Installing fzf..."
if [ "$ARCH" == "x86_64" ]; then
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_amd64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_amd64.tar.gz
else
    wget https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz
    tar -C /usr/bin -xzf fzf-0.57.0-linux_arm64.tar.gz
fi
echo 'eval "$(fzf --bash)"' >> /root/.bashrc

# Display installation results
echo ""
echo "=== Installation Complete ==="
echo "Installed Go version: $(go version)"
echo ""
echo "Installed tools:"
echo "  gopls: $(gopls version 2>/dev/null || echo 'not installed')"
echo "  dlv: $(dlv version 2>/dev/null || echo 'not installed')"
echo "  gotests: $(gotests -version 2>/dev/null || echo 'not installed')"
echo "  gomodifytags: $(gomodifytags -version 2>/dev/null || echo 'not installed')"
echo "  impl: $(impl -version 2>/dev/null || echo 'not installed')"
echo "  goplay: $(goplay -version 2>/dev/null || echo 'not installed')"
echo "  staticcheck: $(staticcheck -version 2>/dev/null || echo 'not installed')"
echo ""
echo "Environment variables have been added to /root/.bashrc"
echo "To use Go in a new shell, run: source /root/.bashrc"
echo "Or restart your shell session." 