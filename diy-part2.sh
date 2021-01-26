#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

mkdir -p package/apps

#adg
git clone --depth=1 https://github.com/kongfl888/luci-app-adguardhome package/apps/luci-app-adguardhome

#openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/apps/luci-app-openclash


# patch dnsmasq
wget -P package/network/services/dnsmasq/patches/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/new/package/900-add-filter-aaaa-option.patch
patch -p1 < ./dnsmasq-add-filter-aaaa-option.patch
patch -p1 < ./luci-add-filter-aaaa-option.patch

## fullcone
# Patch Kernel 解决fullcone冲突
pushd target/linux/generic/hack-5.4
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd

# Patch FireWall 增添fullcone功能
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/project-openwrt/openwrt/raw/master/package/network/config/firewall/patches/fullconenat.patch

# Patch LuCI 增添fullcone开关
patch -p1 < ./luci-app-firewall_add_fullcone.patch

# FullCone 相关组件
svn co https://github.com/Lienol/openwrt/trunk/package/network/fullconenat ./package/network/fullconenat


## SFE
# Patch Kernel 支援SFE
pushd target/linux/generic/hack-5.4
wget https://github.com/coolsnowwolf/lede/raw/master/target/linux/generic/hack-5.4/953-net-patch-linux-kernel-to-support-shortcut-fe.patch
popd

# Patch LuCI 增添SFE开关
patch -p1 < ./luci-app-firewall_add_sfe_switch.patch

# SFE 相关组件
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shortcut-fe package/lean/shortcut-fe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/fast-classifier package/lean/fast-classifier
wget -P package/base-files/files/etc/init.d/ https://github.com/QiuSimons/R2S-R4S-X86-OpenWrt/raw/master/PATCH/duplicate/shortcut-fe

# luci-app-sfe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-sfe ./package/lean/luci-app-sfe
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt ./package/lean/pdnsd-alt

# dockerman
sed -i 's/+docker/+dockerd/g' ./feeds/luci/applications/luci-app-dockerman/Makefile