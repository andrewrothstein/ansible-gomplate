#!/usr/bin/env sh
set -e
DIR=~/Downloads
APP=gomplate
MIRROR=https://github.com/hairyhenderson/gomplate/releases/download

dl() {
    local ver=$1
    local os=$2
    local arch=$3
    local dotexe=${4:-}
    local platform="${os}-${arch}"
    local rfile="${APP}_${platform}${dotexe}"
    local url=$MIRROR/v$ver/$rfile
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep -e "$rfile\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1

    # https://github.com/hairyhenderson/gomplate/releases/download/v3.11.3/checksums-v3.11.3_sha256.txt
    local url=$MIRROR/v$ver/checksums-v${ver}_sha256.txt

    local lchecksums=$DIR/gomplate-${ver}-checksums.txt
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl $ver freebsd amd64
    dl $ver linux amd64
    dl $ver linux 386
    dl $ver linux armv6
    dl $ver linux armv7
    dl $ver linux arm64
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver solaris amd64
    dl $ver windows amd64 .exe
    dl $ver windows 386.exe
    dl $ver linux amd64-slim
    dl $ver linux armv6-slim
    dl $ver linux armv7-slim
    dl $ver linux arm64-slim
    dl $ver darwin amd64-slim
    dl $ver windows amd64-slim .exe
}

dl_ver ${1:-3.11.3}
