#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate

#extra
git clone --depth=1 https://github.com/kenzok8/openwrt-packages package/new

git clone --depth=1 https://github.com/kenzok8/small package/small

git clone --depth=1 https://github.com/fw876/helloworld package/lean/helloworld

rm -rf package/lean/default-settings/files/zzz-default-settings
mv ${GITHUB_WORKSPACE}/zzz-default-settings package/lean/default-settings/files/