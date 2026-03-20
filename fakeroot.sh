#!/bin/bash
mkdir -p $HOME/debian
cd $HOME/debian

curl -L https://github.com/debuerreotype/docker-debian-artifacts/raw/dist-amd64/bookworm/rootfs.tar.xz -o debian-rootfs.tar.xz ; tar -xJf debian-rootfs.tar.xz ; unshare --user --map-root-user --mount --pid --fork chroot $HOME/debian /bin/bash
