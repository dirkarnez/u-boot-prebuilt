#!/bin/bash

echo "User: $(whoami) UID: $(id -u) GID: $(id -g)"

gcc --version

# an echo that will stand out in the logs
function announce () {
	whole_line_length=80
    announcement="$*"
    announcement_length=${#announcement}
	
    pad_whole_line=$(printf '%*s' $whole_line_length | tr ' ' '#')
	pad_announcement_left_length=$((($whole_line_length / 2) - (announcement_length - 2) - 2))
    pad_announcement_left=$(printf '%*s' $pad_announcement_left_length | tr ' ' '#')
	
	pad_announcement_right_length=$(($whole_line_length - $pad_announcement_left_length - 4 - $announcement_length))
    pad_announcement_right=$(printf '%*s' $pad_announcement_right_length | tr ' ' '#')

    echo $size
    echo $pad_whole_line
    echo "$pad_announcement_left  $*  $pad_announcement_right"
    echo $pad_whole_line
}

set -e

# git clone --branch v2018.01-solidrun-imx6 https://github.com/SolidRun/u-boot.git u-boot-imx6-github && \
# cd u-boot-imx6-github && \

# export UBOOT_CONFIG="mx6cuboxi_defconfig"
# make mrproper
# 

# install -v -m644 -D ./SPL /dist/SPL && \
# install -v -m644 -D ./u-boot.img /dist/u-boot.img && \
export PATH="/opt/arm-gnu-toolchain-15.2.rel1-x86_64-aarch64-none-linux-gnu/bin:$PATH" && \
aarch64-none-linux-gnu-gcc --version && \
git clone --recurse-submodules --depth 1 --branch v2025.10 https://github.com/u-boot/u-boot.git && \
cd /workspace/u-boot && \
export CROSS_COMPILE="aarch64-none-linux-gnu-" && \
announce "Building u-boot" && \
make qemu_arm64_defconfig && \
echo "CONFIG_EXAMPLES =y" >> .config && \
cat .config && \
make -j16 CROSS_COMPILE=aarch64-none-linux-gnu- && \
announce "image build appears to have been successful" && \
ls -R && \
announce "copying files" && \
install -v -m644 -D ./u-boot.bin /dist/u-boot.bin && \
install -v -m644 -D ./examples/standalone/hello_world.bin /dist/hello_world.bin && \
announce "files copied"



# for file in $(find source -type f -name *.py); do
#     install -m 644 -D ${file} dest/${file#source/}
# done
