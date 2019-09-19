#!/bin/bash

declare -a KERNELS

while read -r KERNEL; do
    KERNELS+=($KERNEL)
done

##KERNELS=($(pacman -Ql | grep vmlinuz-linux | awk '{print $1}'))
KERNEL_VERS=($(pacman -Q ${KERNELS[@]} | awk '{sub(/.arch/,"-arch"); print $2}'))

OPTS="-f -H --no-hostonly-cmdline"

N_KERNELS=$(( ${#KERNELS[@]}-1 ))

for i in $(seq 0 1 $N_KERNELS); do

    KERNEL=${KERNELS[$i]}
    KERNEL_VERS=${KERNEL_VERS[$i]}
 
    echo "==> Generating initramfs for:" $KERNEL $KERNEL_VERS

    [[ $KERNEL = "linux" ]] && SUFFIX='-ARCH' ||  SUFFIX=$(echo $KERNEL | sed 's/linux//' )

    dracut $OPTS --kver $KERNEL_VERS$SUFFIX /boot/initramfs-$KERNEL-dracut.img 2>&1 | sed 's/dracut:\(.*\)/  ->\1/'

done

