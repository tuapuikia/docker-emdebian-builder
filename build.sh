#!/bin/sh

set -xe

mkdir -p /chroot
mount -t tmpfs tmpfs /chroot
multistrap -f /multistrap.conf
rm -rfv /chroot/var/lib/apt/lists/*
cp -v /etc/apt/sources.list /chroot/etc/apt/sources.list.d/multistrap-ubuntu.list
rsync -a /chroot/ /rootfs
umount /chroot
rsync -a /rootfs/ /chroot/
