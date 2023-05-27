#!/bin/bash

# 删除软件包
rm -rf feeds/luci/applications/luci-app-serverchan

# 添加软件包
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome
git clone https://github.com/sbwml/luci-app-alist package/alist
svn co https://github.com/ophub/luci-app-amlogic/trunk/luci-app-amlogic package/luci-app-amlogic
svn co https://github.com/kenzok8/openwrt-packages/trunk/luci-app-eqos package/luci-app-eqos
git clone https://github.com/tty228/luci-app-serverchan feeds/luci/applications/luci-app-serverchan
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/luci-app-openclash
git clone https://github.com/xiaorouji/openwrt-passwall package/passwall
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall package/luci-app-passwall
git clone https://github.com/fw876/helloworld package/helloworld
git clone https://github.com/jerrykuku/luci-app-vssr package/luci-app-vssr
git clone https://github.com/jerrykuku/lua-maxminddb package/lua-maxminddb
git clone https://github.com/sensec/openwrt-udp2raw package/openwrt-udp2raw
git clone https://github.com/sensec/luci-app-udp2raw package/luci-app-udp2raw
sed -i "s/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=f2f90a9a150be94d50af555b53657a2a4309f287/" package/openwrt-udp2raw/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=20200920\.0/" package/openwrt-udp2raw/Makefile
svn co https://github.com/breakings/OpenWrt/trunk/general

# 替换argon主题
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon feeds/luci/themes/luci-theme-argon

# 编译 po2lmo (如果有po2lmo可跳过)
cd package/luci-app-openclash/tools/po2lmo
make && sudo make install
cd -

# 配置修改
# replace banner
cp -f banner package/base-files/files/etc/banner

# autocore
sed -i 's/DEPENDS:=@(.*/DEPENDS:=@(TARGET_bcm27xx||TARGET_bcm53xx||TARGET_ipq40xx||TARGET_ipq806x||TARGET_ipq807x||TARGET_mvebu||TARGET_rockchip||TARGET_armvirt) \\/g' package/lean/autocore/Makefile

# readd cpufreq for aarch64
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g'  feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# replace coremark.sh with the new one
rm -f feeds/packages/utils/coremark/coremark.sh
cp -f general/coremark.sh feeds/packages/utils/coremark

# fix ntfs3 generating empty package
sed -i 's/DEPENDS:=.*/DEPENDS:=@(LINUX_5_4||LINUX_5_10) +kmod-nls-utf8/g' package/lean/ntfs3-oot/Makefile

# luci-app-openvpn
sed -i 's/services/vpn/g'  feeds/luci/applications/luci-app-openvpn/luasrc/controller/openvpn.lua
sed -i 's/services/vpn/g'  feeds/luci/applications/luci-app-openvpn/luasrc/model/cbi/openvpn.lua
sed -i 's/services/vpn/g'  feeds/luci/applications/luci-app-openvpn/luasrc/view/openvpn/pageswitch.htm

# 晶晨宝盒
#sed -i "s|https.*/amlogic-s9xxx-openwrt|https://github.com/breakings/OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic
#sed -i "s|http.*/library|https://github.com/breakings/OpenWrt|g" package/luci-app-amlogic/root/etc/config/amlogic
#sed -i "s|s9xxx_lede|ARMv8|g" package/luci-app-amlogic/root/etc/config/amlogic

# 更新包
# at
rm -rf feeds/packages/utils/at
cp -rf general/at feeds/packages/utils

# bcrypt
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=3.2.2/g' feeds/packages/lang/python/bcrypt/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/lang/python/bcrypt/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=433c410c2177057705da2a9f2cd01dd157493b2a7ac14c8593a16b3dab6b6bfb/g' feeds/packages/lang/python/bcrypt/Makefile

# bind
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=9.18.14/g' feeds/packages/net/bind/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=9ae12edf6ac3c430b33ecd1a7c0c0c60875d255185eb87850fa9a5e794a64a09/g' feeds/packages/net/bind/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/net/bind/Makefile

# boost
rm -rf feeds/packages/libs/boost
cp -rf general/boost feeds/packages/libs

# btrfs-progs
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=6.3/g' feeds/packages/utils/btrfs-progs/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=40a0bdff787ecb490e5533dbcefd4852176daf12aae5a1158203db43d8ad6a7d/g' feeds/packages/utils/btrfs-progs/Makefile
rm -rf feeds/packages/utils/btrfs-progs/patches

# containerd
cp -f general/containerd/Makefile feeds/packages/utils/containerd

# docker
rm -rf feeds/packages/utils/docker
cp -rf general/docker feeds/packages/utils

# dockerd
rm -rf feeds/packages/utils/dockerd
cp -rf general/dockerd feeds/packages/utils

# docker-compose
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.17.3/g' feeds/packages/utils/docker-compose/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=e5e9bdfc3a827240381b656da88f92b408ea2e203c3f8cfd9e0bbfe03f825f16/g' feeds/packages/utils/docker-compose/Makefile

# dnsproxy
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=0.49.1/g' feeds/packages/net/dnsproxy/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=c587a7e88660c879f738df1ffcbf0402928a0c04ec0f148e385017f176e8ba14/g' feeds/packages/net/dnsproxy/Makefile

# file
cp -f general/file/Makefile feeds/packages/libs/file/Makefile

# flac
rm -rf feeds/packages/libs/flac
cp -rf general/flac feeds/packages/libs

# frp
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=0.48.0/g' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=efba8ec9fad3369ce62631369f52b78a7248df426b5b54311e96231adac5cc76/g' feeds/packages/net/frp/Makefile

# gawk
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.2.1/g' feeds/packages/utils/gawk/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=673553b91f9e18cc5792ed51075df8d510c9040f550a6f74e09c9add243a7e4f/g' feeds/packages/utils/gawk/Makefile

# golang
#rm -rf feeds/packages/lang/golang
#cp -rf general/golang feeds/packages/lang

# gzip
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.12/g' feeds/packages/utils/gzip/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/utils/gzip/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=ce5e03e519f637e1f814011ace35c4f87b33c0bbabeec35baf5fbd3479e91956/g' feeds/packages/utils/gzip/Makefile

# haproxy
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.6.13/g' feeds/packages/net/haproxy/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/net/haproxy/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=d69ff5233dbca657132ef280d111222ec1e33f5be1c1937d4e9ff516f63f5243/g' feeds/packages/net/haproxy/Makefile
sed -i 's/BASE_TAG:=.*/BASE_TAG=v2.6.13/g' feeds/packages/net/haproxy/get-latest-patches.sh

# hwdata
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=0.368/g' feeds/packages/utils/hwdata/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=d3db5f4d08a0ba2e4d776fba507662399816e75a14af78bd25dd3c8f2fb8e951/g' feeds/packages/utils/hwdata/Makefile

# icu
rm -rf feeds/packages/libs/icu
svn co https://github.com/openwrt/packages/trunk/libs/icu feeds/packages/libs/icu

# less
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=608/g' feeds/packages/utils/less/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=a69abe2e0a126777e021d3b73aa3222e1b261f10e64624d41ec079685a6ac209/g' feeds/packages/utils/less/Makefile

# libnetwork
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=05b93e0d3a95952f70c113b0bc5bdb538d7afdd7/g' feeds/packages/utils/libnetwork/Makefile
sed -i 's/PKG_SOURCE_DATE:=.*/PKG_SOURCE_DATE:=2023-01-19/g' feeds/packages/utils/libnetwork/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=d1f590909e7e70dca3a02ce194015208291fcc28d1f13bb5c23d68194f18660f/g' feeds/packages/utils/libnetwork/Makefile

# libtorrent-rasterbar_v2
rm -rf feeds/packages/libs/libtorrent-rasterbar/patches
cp -f general/libtorrent-rasterbar/Makefile feeds/packages/libs/libtorrent-rasterbar

# lsof
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.95.0/g' feeds/packages/utils/lsof/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=e9faa0fbcc48638c1d1f143e93573ac43b65e76646150f83e24bd8c18786303c/g' feeds/packages/utils/lsof/Makefile

# nghttp2
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.52.0/g' feeds/packages/libs/nghttp2/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=3ea9f0439e60469ad4d39cb349938684ffb929dd7e8e06a7bffe9f9d21f8ba7d/g' feeds/packages/libs/nghttp2/Makefile

# nginx
rm -rf feeds/packages/net/nginx
cp -rf general/nginx feeds/packages/net

# openssh
rm -rf feeds/packages/net/openssh
cp -rf general/openssh feeds/packages/net

# parted
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=3.6/g' feeds/packages/utils/parted/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=3b43dbe33cca0f9a18601ebab56b7852b128ec1a3df3a9b30ccde5e73359e612/g' feeds/packages/utils/parted/Makefile

# pcre
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=8.45/g' package/libs/pcre/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' package/libs/pcre/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8/g' package/libs/pcre/Makefile

# pcre2
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=10.42/g' feeds/packages/libs/pcre2/Makefile
sed -i 's|PKG_SOURCE_URL:=.*|PKG_SOURCE_URL:=https://github.com/PCRE2Project/pcre2/releases/download/$(PKG_NAME)-$(PKG_VERSION)|g' feeds/packages/libs/pcre2/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=8d36cd8cb6ea2a4c2bb358ff6411b0c788633a2a45dabbf1aeb4b701d1b5e840/g' feeds/packages/libs/pcre2/Makefile

# perl
rm -rf feeds/packages/lang/perl
cp -rf general/perl feeds/packages/lang

# php8
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=8.2.5/g' feeds/packages/lang/php8/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=800738c359b7f1e67e40c22713d2d90276bc85ba1c21b43d99edd43c254c5f76/g' feeds/packages/lang/php8/Makefile

# python3
sed -i 's/PYTHON3_VERSION_MICRO:=.*/PYTHON3_VERSION_MICRO:=9/g' feeds/packages/lang/python/python3-version.mk
sed -i 's/PYTHON3_SETUPTOOLS_VERSION:=.*/PYTHON3_SETUPTOOLS_VERSION:=65.5.0/g' feeds/packages/lang/python/python3-version.mk
sed -i 's/PYTHON3_PIP_VERSION:=.*/PYTHON3_PIP_VERSION:=22.3.1/g' feeds/packages/lang/python/python3-version.mk
sed -i 's/PKG_HASH:=.*/PKG_HASH:=5ae03e308260164baba39921fdb4dbf8e6d03d8235a939d4582b33f0b5e46a83/g' feeds/packages/lang/python/python3/Makefile
rm -rf feeds/packages/lang/python/python3/patches-pip

# python-certifi
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2022.12.7/g' feeds/packages/lang/python/python-certifi/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3/g' feeds/packages/lang/python/python-certifi/Makefile

# python-click
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=8.1.3/g' feeds/packages/lang/python/click/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e/g' feeds/packages/lang/python/click/Makefile

# python-dns
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.2.1/g' feeds/packages/lang/python/python-dns/Makefile
sed -i 's/PYPI_SOURCE_EXT:=.*/PYPI_SOURCE_EXT:=tar.gz/g' feeds/packages/lang/python/python-dns/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e/g' feeds/packages/lang/python/python-dns/Makefile

# python-dotenv
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.0.0/g' feeds/packages/lang/python/python-dotenv/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=a8df96034aae6d2d50a4ebe8216326c61c3eb64836776504fcca410e5937a3ba/g' feeds/packages/lang/python/python-dotenv/Makefile

# python-idna
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=3.4/g' feeds/packages/lang/python/python-idna/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4/g' feeds/packages/lang/python/python-idna/Makefile

# python-jsonschema
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.17.3/g' feeds/packages/lang/python/python-jsonschema/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d/g' feeds/packages/lang/python/python-jsonschema/Makefile

# python-lxml
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.9.2/g' feeds/packages/lang/python/python-lxml/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67/g' feeds/packages/lang/python/python-lxml/Makefile

# python-packaging
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=21.3/g' feeds/packages/lang/python/python-packaging/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb/g' feeds/packages/lang/python/python-packaging/Makefile

# python-paramiko
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=3.1.0/g' feeds/packages/lang/python/python-paramiko/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=6950faca6819acd3219d4ae694a23c7a87ee38d084f70c1724b0c0dbb8b75769/g' feeds/packages/lang/python/python-paramiko/Makefile

# python-pyrsistent
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=0.19.3/g' feeds/packages/lang/python/python-pyrsistent/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440/g' feeds/packages/lang/python/python-pyrsistent/Makefile

# python-requests
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.28.2/g' feeds/packages/lang/python/python-requests/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/lang/python/python-requests/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf/g' feeds/packages/lang/python/python-requests/Makefile

# python-simplejson
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=3.19.1/g' feeds/packages/lang/python/python-simplejson/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=6277f60848a7d8319d27d2be767a7546bc965535b28070e310b3a9af90604a4c/g' feeds/packages/lang/python/python-simplejson/Makefile

# python-sqlalchemy
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=2.0.9/g' feeds/packages/lang/python/python-sqlalchemy/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=95719215e3ec7337b9f57c3c2eda0e6a7619be194a5166c07c1e599f6afc20fa/g' feeds/packages/lang/python/python-sqlalchemy/Makefile

# python-urllib3
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.26.15/g' feeds/packages/lang/python/python-urllib3/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305/g' feeds/packages/lang/python/python-urllib3/Makefile

# python-websocket-client
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.5.1/g' feeds/packages/lang/python/python-websocket-client/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=3f09e6d8230892547132177f575a4e3e73cfdf06526e20cc02aa1c3b47184d40/g' feeds/packages/lang/python/python-websocket-client/Makefile

# qBittorrent (use cmake)
cp -f general/qBittorrent/Makefile feeds/packages/net/qBittorrent/Makefile

# Qt5 -qtbase
sed -i "s/PKG_BUGFIX:=.*/PKG_BUGFIX:=9/g" feeds/packages/libs/qtbase/Makefile
sed -i "s/PKG_HASH:=.*/PKG_HASH:=1947deb9d98aaf46bf47e6659b3e1444ce6616974470523756c082041d396d1e/g" feeds/packages/libs/qtbase/Makefile

# Qt5 -qttools
sed -i "s/PKG_BUGFIX:=.*/PKG_BUGFIX:=9/g" feeds/packages/libs/qttools/Makefile
sed -i "s/PKG_HASH:=.*/PKG_HASH:=40dce7845bc156dce7878b304e05b19f1ce7dedd4221c67af3bdf0138196006d/g" feeds/packages/libs/qttools/Makefile

# ruby
rm -rf feeds/packages/lang/ruby
svn co https://github.com/openwrt/packages/trunk/lang/ruby feeds/packages/lang/ruby

# runc
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.1.5/g' feeds/packages/utils/runc/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=76cbf30637cbb828794d72d32fb3fd6ff3139cd9743b8b44790fd110f43d96b2/g' feeds/packages/utils/runc/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=f19387a6bec4944c770f7668ab51c4348d9c2f38/g' feeds/packages/utils/runc/Makefile

# Samba4
rm -rf feeds/packages/net/samba4
svn co https://github.com/openwrt/packages/trunk/net/samba4 feeds/packages/net/samba4

# shairport-sync
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=4.1.1/g' feeds/packages/sound/shairport-sync/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=e55caad73dcd36341baf8947cf5e0923997370366d6caf3dd917b345089c4a20/g' feeds/packages/sound/shairport-sync/Makefile

# socat
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.4.4/g' feeds/packages/net/socat/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=fbd42bd2f0e54a3af6d01bdf15385384ab82dbc0e4f1a5e153b3e0be1b6380ac/g' feeds/packages/net/socat/Makefile

# sqlite3
rm -rf feeds/packages/libs/sqlite3
cp -rf general/sqlite3 feeds/packages/libs

# tailscale
rm -rf feeds/packages/net/tailscale
cp -rf general/tailscale feeds/packages/net

# transmission-web-control
sed -i 's/PKG_SOURCE_DATE:=.*/PKG_SOURCE_DATE:=2021-09-25/g' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=4b2e1858f7a46ee678d5d1f3fa1a6cf2c739b88a/g' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=ea014c295766e2efc7b890dc6a6940176ba9c5bdcf85a029090f2bb850e59708/g' feeds/packages/net/transmission-web-control/Makefile

# ttyd
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.3/g' feeds/packages/utils/ttyd/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/utils/ttyd/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=c9cf5eece52d27c5d728000f11315d36cb400c6948d1964a34a7eae74b454099/g' feeds/packages/utils/ttyd/Makefile
rm -f feeds/packages/utils/ttyd/patches/090*.patch

# unrar
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=6.2.6/g' feeds/packages/utils/unrar/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=0c2d4cbc8b34d0e3bec7b474e0f52bbcc6c4320ec089b4141223ee355f63c318/g' feeds/packages/utils/unrar/Makefile

# util-linux
rm -rf package/utils/util-linux
cp -rf general/util-linux package/utils

# vim
rm -rf feeds/packages/utils/vim
cp -rf general/vim feeds/packages/utils

# wsdd2
sed -i 's/PKG_SOURCE_DATE:=.*/PKG_SOURCE_DATE:=2022-04-25/g' feeds/packages/net/wsdd2//Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=e37443ac4c757dbf14167ec3f754ebe88244ad4b/g' feeds/packages/net/wsdd2//Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=45e0c37b8e275c8d088506f953aa25b30a31600ce67ccb4f60b1eda6688a5a8b/g' feeds/packages/net/wsdd2//Makefile

# xz
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=5.4.2/g' feeds/packages/utils/xz/Makefile
sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/packages/utils/xz/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=aa49909cbd9028c4666a35fa4975f9a6203ed98154fbb8223ee43ef9ceee97c3/g' feeds/packages/utils/xz/Makefile

# zoneinfo
cp -f general/zoneinfo/Makefile feeds/packages/utils/zoneinfo

# zstd
sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.5.5/g' feeds/packages/utils/zstd/Makefile
sed -i 's/PKG_HASH:=.*/PKG_HASH:=9c4396cc829cfae319a6e2615202e82aad41372073482fce286fac78646d3ee4/g' feeds/packages/utils/zstd/Makefile
sed -i 's/Dbacktrace=false/Dbacktrace=disabled/g' feeds/packages/utils/zstd/Makefile

# 更新包
./scripts/feeds update -a
./scripts/feeds install -a