#!/bin/bash

qemu-system-x86_64 \
		-kernel ${KERNELD:-.}/bzImage \
		-initrd ${KERNELD:-.}/dist.cpio.gz \
		-monitor /dev/null \
		-nographic \
		-append "console=ttyS0"

