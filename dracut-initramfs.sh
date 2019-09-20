#!/bin/bash

# Need to think about filtering input like linux-headers
# Checking for vmlinuz-linux seems to be working
declare -a KERNELS

while read -r PACKAGE; do
    pacman -Ql "$PACKAGE" | grep vmlinuz-linux > /dev/null && KERNELS+=($PACKAGE)
done

#KERNELS=($(pacman -Ql | grep vmlinuz-linux | awk '{print $1}'))
# fix for linux-zen, oops
KERNEL_VERS=($(pacman -Q ${KERNELS[@]} | awk '{sub(/\.arch/,"-arch");sub(/\.zen/,"-zen"); print $2}'))

OPTS="-f -H --no-hostonly-cmdline"

N_KERNELS=$(( ${#KERNELS[@]}-1 ))

for i in $(seq 0 1 $N_KERNELS); do

    KERNEL=${KERNELS[$i]}
    KERNEL_VER=${KERNEL_VERS[$i]}

    # linux 5.3 breaks since /usr/lib/modules/5.3.0
    if [[ ! "$KERNEL_VER" =~ [1-9]*\.[1-9]*\.[1-9]*.* ]]; then
        KERNEL_VER=$(echo $KERNEL_VER | sed 's/\([1-9]*\.[1-9]*\)\(.*\)/\1\.0\2/')
    fi

    echo "==> Generating initramfs for:" $KERNEL $KERNEL_VER

    [[ $KERNEL = "linux" ]] && SUFFIX='-ARCH' ||  SUFFIX=$(echo $KERNEL | sed 's/linux//' )

    dracut $OPTS --kver $KERNEL_VER$SUFFIX /boot/initramfs-$KERNEL-dracut.img 2>&1 | sed -u 's/dracut:\(.*\)/  ->\1/'

done

