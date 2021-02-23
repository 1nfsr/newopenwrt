#!/bin/bash

# 移除SNAPSHOT标签
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
sed -i 's/ %V,//g' package/base-files/files/etc/banner

# 使用O2级别的优化
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2/O2/g' ./rules.mk

# 修改最大连接数
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# 添加自定义信息
sed -i '/DISTRIB_DESCRIPTION/d' package/base-files/files/etc/openwrt_release
sed -i "$ a\DISTRIB_DESCRIPTION='Built by Infsr($(date +%Y.%m.%d))@%D %V %C'" package/base-files/files/etc/openwrt_release
sed -i '/%D/a\ Infsr Build' package/base-files/files/etc/banner

# change shells
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# fix login
sed -i 's/ash/bash/g' package/base-files/files/usr/libexec/login.sh
#
#::askconsole:/usr/libexec/login.sh package/base-files/files/etc/inittab
sed -i 's/::askconsole/#::askconsole/g' package/base-files/files/etc/inittab
#
echo 'kernel.printk=0 4 1 7' >> package/base-files/files/etc/sysctl.conf

sed -i 's/ash/bash/g' package/base-files/files/etc/shells

#use 5.10kernel
sed -i 's/KERNEL_TESTING_PATCHVER:=5.4/KERNEL_TESTING_PATCHVER:=5.10/g' target/linux/x86/Makefile
cp target/linux/generic/config-5.10 target/linux/x86/
cp target/linux/generic/config-5.10 target/linux/x86/generic/
cp target/linux/generic/config-5.10 target/linux/x86/64/
cp -r target/linux/x86/patches-5.4 target/linux/x86/patches-5.10

