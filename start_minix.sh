#!/bin/bash

SSH_PORT=2222
MINIX_IMG=minix.img

qemu-system-x86_64 -curses -drive file=${MINIX_IMG} -localtime -net user,hostfwd=tcp::${SSH_PORT}-:22 -net nic,model=virtio -m 1024M -enable-kvm
