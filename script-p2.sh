#!/bin/bash

# Modify default IP
sed -i 's/192.168.1.1/192.168.77.1/g' package/base-files/files/bin/config_generate

mkdir -p package/diy
git clone https://github.com/frainzy1477/luci-app-clash.git package/diy/luci-app-clash
git clone https://github.com/kongfl888/luci-app-adguardhome.git package/diy/luci-app-adguardhome