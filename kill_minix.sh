#!/bin/bash

PID=`ps aux | grep "qemu-system-x86_64 -curses -drive file=minix.img -localtime -net user,hostfwd=tcp::2222-:22 -net nic,model=virtio -m 1024M -enable-kvm" | grep -v grep | cut -d" " -f2`
kill -9 $PID
