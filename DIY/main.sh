#!/bin/bash
function git_sparse_clone() {                                                 ## 只下载指定的目录，并移动到根目录；
branch="$1" rurl="$2" localdir="$3" && shift 3                                ## 变量：branch=分支   rurl=链接    localdir=本地根目录
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
# git clone -b 1 --depth 1 --filter=blob:none --sparse 2 3
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd ..
rm -rf $localdir
}



function git_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
# find package/ -follow -name $pkg -not -path "package/openwrt-packages/*" | xargs -rt rm -rf
    localdir=./                            # 变量= 保存的文件路径
    git clone --depth=1 --single-branch $1
    [ -d "$localdir" ] || mkdir -p "$localdir"   # 判断当前是否有 download 目录，如果不存在 则新创建 download 目录；= (-d 判断目录是否存在)  (mkdir -p 判断结果：如果目录不存在，则新创建 download 目录)
    mv $2 "$localdir"                            # 移动下载的文件 至 download 目录内；
    rm -rf $repo
}
##命令用法： git_package https://github.com/coolsnowwolf/luci luci/applications/luci-app-ddns   # git_package 加仓库链接  加仓库的文件路径



function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./                                       ## 移动分支内所有文件到 当前目录；  -n 不覆盖已存在的文件
rm -rf $1
}



### 科学上网插件             ## 克隆到 .github 目录内, 与diy、workflows、同个路径
git clone --depth 1 https://github.com/kiddin9/openwrt-packages && mv -n openwrt-packages/{luci-app-bypass,lua-maxminddb,lua-neturl} ./ ; rm -rf openwrt-packages     # 保留：luci-app-bypass + 插件依赖包
mv {lua-maxminddb,lua-neturl} luci-app-bypass                                    # lua-maxminddb,lua-neturl 移动依赖包
### git clone --depth 1 https://github.com/jerrykuku/lua-maxminddb.git																								  # luci-app-bypass插件的其中一个依赖包

git clone --depth 1 https://github.com/vernesong/OpenClash.git && mv -n OpenClash/luci-app-openclash ./; rm -rf OpenClash                       # OenClash小猫咪
### git clone --depth 1 https://github.com/hubbylei/luci-app-clash.git
### https://github.com/frainzy1477/luci-app-clash

git clone --depth 1 -b main https://github.com/xiaorouji/openwrt-passwall passwall1 && mv -n passwall1/luci-app-passwall  ./; rm -rf passwall1  # passwall1（主插件！！）
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall2 passwall2 && mv -n passwall2/luci-app-passwall2 ./;rm -rf passwall2          # passwall2（主插件！！）
git clone --depth 1 -b main https://github.com/xiaorouji/openwrt-passwall-packages luci-app-passwall-wall                                 			    # passwall     插件依赖包

git clone --depth 1 https://github.com/fw876/helloworld luci-app-ssr-plus																		# luci-app-ssr-plus
### git clone --depth 1 https://github.com/fw876/helloworld && mv -n helloworld/{lua-neturl,shadow-tls,tuic-client,luci-app-ssr-plus} ./ ; rm -rf helloworld   # 保留：luci-app-ssr-plus + tuic-client + shadow-tls
### mv {lua-neturl,shadow-tls,tuic-client} luci-app-ssr-plus                        # 移动 tuic-client + shadow-tls 文件

git clone -b main https://github.com/linkease/istore luci-app-store                                                                             # luci-app-store 开源软件中心（指定下载main分支）

git clone --depth 1 https://github.com/destan19/OpenAppFilter.git OpenAppFilter && mv -n OpenAppFilter/{luci-app-oaf,oaf,open-app-filter} ./; rm -rf OpenAppFilter   # 下载OpenAppFilter 应用访问过滤
mkdir -p OpenAppFilter && mv {luci-app-oaf,oaf,open-app-filter} OpenAppFilter   # 移动OpenAppFilter文件

git clone --depth 1 -b master https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git                                           # 解锁网易云音乐
### https://github.com/immortalwrt/luci-app-unblockneteasemusic.git 

git clone --depth 1 https://github.com/zzsj0928/luci-app-pushbot.git                                                                            # luci-app-pushbot       全能推送插件
### git clone --depth 1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush.git                                                          # luci-app-wechatpush   （微信/Telegram）推送插件


git clone --depth 1 https://github.com/Hyy2001X/AutoBuild-Packages && mv -n AutoBuild-Packages/luci-app-adguardhome ./; rm -rf AutoBuild-Packages   # Adguardhome AD去广告
### git clone --depth 1 https://github.com/kenzok78/luci-app-adguardhome																			# Adguardhome AD去广告
### git clone --depth 1 https://github.com/kenzok8/wall.git && mv -n wall/{adguardhome,filebrowser,gost} ./; rm -rf wall			  	            # 保留：Adguardhome filebrowser（网盘） gost（gost VPN隧道）

git clone --depth 1 https://github.com/sbwml/luci-app-alist.git luci-alist && mv -n luci-alist/*alist ./ ; rm -rf luci-alist					    # Alist阿雅网盘（注意：编译前需安装依赖：sudo apt install libfuse-dev）
mv alist luci-app-alist                                                         # 移动alist文件
### https://github.com/lmq8267/luci-app-alist

git clone --depth 1 https://github.com/lisaac/luci-app-dockerman.git dockerman && mv -n dockerman/applications/* ./; rm -rf dockerman               # Docker容器管理
git clone --depth 1 https://github.com/lisaac/luci-app-diskman.git                                                                                  # Diskman 磁盘分区管理

git clone --depth 1 https://github.com/sirpdboy/luci-app-poweroffdevice.git                                                                         # 设备关机
### git clone --depth 1 https://github.com/esirplayground/luci-app-poweroff                                                                              # 关机插件

#git clone --depth 1 https://github.com/sirpdboy/luci-app-autotimeset.git                                                                           # 插件 执行定时任务
#git clone --depth 1 https://github.com/sirpdboy/netspeedtest.git                                                                                   # 网络速度测试
#git clone --depth 1 https://github.com/sirpdboy/luci-app-advanced.git                                                                              # 系统高级设置   高级设置（内置luci-app-fileassistant文件助手）
#git clone --depth 1 https://github.com/sirpdboy/luci-app-netwizard.git                                                                             # 设置向导
#git clone --depth 1 https://github.com/sirpdboy/luci-app-lucky.git                                                                                 # Lucky大吉 IPv4/IPv6端口转发,动态域名服务,http/https反向代理，默认用户名密码666..（替代socat,主要用于公网IPv6 tcp/udp转 内网ipv4）
#git clone --depth 1 https://github.com/sirpdboy/luci-app-partexp.git                                                                               # 一键分区扩容挂载工具

#git clone --depth 1 https://github.com/sirpdboy/luci-app-ddns-go.git ddnsgo && mv -n ddnsgo/{luci-app-ddns-go,ddns-go} ./; rm -rf ddnsgo                  # ddns-go动态域名
#mv ddns-go luci-app-ddns-go                                                   # 移动 ddns-go 文件夹

# 大灰狼的专用软件包
#git clone --depth 1 https://github.com/shidahuilang/openwrt-package.git && mv -n openwrt-package/{luci-app-homeredirect,luci-app-quickstart} ./ ; rm -rf openwrt-package   
# 保留：luci-app-adblock-plus,luci-app-homeredirect（端口转发）,luci-app-quickstart（iStoreOS-web）



#git clone --depth 1 https://github.com/honwen/luci-app-aliddns.git																				    # 阿里DDNS
#git clone --depth 1 https://github.com/kiddin9/luci-app-dnsfilter.git                                                                              # DNS 过滤器
#git clone --depth 1 https://github.com/ophub/luci-app-amlogic.git amlogic && mv -n amlogic/luci-app-amlogic ./;rm -rf amlogic                      # 晶晨宝盒（N1或电视盒子）
#git clone --depth 1 https://github.com/rufengsuixing/luci-app-onliner.git package/luci-app-onliner                                                 # Online User 显示在线主机 需要luci-app-nlbwmon
# git clone --depth 1 https://github.com/ntlf9t/luci-app-easymesh.git	                                                                            # 简单MESH易网
# git clone --depth 1 https://github.com/Huangjoe123/luci-app-eqos.git	                                                                            # EQoS
# git clone --depth 1 https://github.com/messense/aliyundrive-webdav.git aliyundrive && mv -n aliyundrive/openwrt/* ./ ; rm -rf aliyundrive		    # 保留：aliyundrive-webdav + luci-app-aliyundrive-webdav阿里云盘v 2.3.2
# git clone --depth 1 https://github.com/kenzok78/luci-app-fileassistant.git                                                                        # 文件助手
# git clone --depth 1 https://github.com/yaof2/luci-app-ikoolproxy.git                                                                              # 爱酷代理
# git clone --depth 1 https://github.com/jefferymvp/luci-app-koolproxyR.git                                                                         # KoolProxyR plus+广告屏蔽
# git clone --depth 1 -b lede https://github.com/pymumu/luci-app-smartdns.git                                                                       # SmartDNS 服务器
# # git clone --depth 1 https://github.com/QiuSimons/openwrt-mos.git && mv -n openwrt-mos/*mosdns ./ ; rm -rf openwrt-mos                           # 保留插件：mosdns + luci-app-mosdns
# git clone --depth 1 https://github.com/sbwml/luci-app-mosdns.git openwrt-mos && mv -n openwrt-mos/{*mosdns,v2dat} ./; rm -rf openwrt-mos          # 保留插件：v2dat + mosdns + luci-app-mosdns
# git clone https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/otherapp/mentohust                                                     # 校园网认证
# git clone --depth=1 https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk package/otherapp/MentoHUST-OpenWrt-ipk                                   # luci-app-mentohust
# git clone --depth=1 https://github.com/BoringCat/luci-app-mentohust                                                                               # luci-app-mentohust
# git clone --depth=1 https://github.com/garypang13/luci-app-dnsfilter package/luci-app-dnsfilter                                                   # DNS的广告过滤
# git clone --depth=1 https://github.com/ysc3839/luci-proto-minieap                                                                                 # luci-proto-minieap
# git clone --depth=1 https://github.com/KFERMercer/luci-app-dockerman                                                                              # Docker
# git clone --depth=1 https://github.com/project-openwrt/openwrt-gowebdav                                                                           # WebDav 服务端程序


# 长期不维护的源码
# https://github.com/pppoex/openwrt-packages?tab=readme-ov-file
git clone --depth=1 https://github.com/f8q8/luci-app-autoreboot luci-app-autoreboot     # 自动重启

git clone --depth=1 https://github.com/kiddin9/luci-app-wizard luci-app-wizard          # 快捷设置
























# 主题源码
git clone --depth=1 https://github.com/openwrt-develop/luci-theme-atmaterial.git                       # atmaterials 主题（不推荐）
### git clone --depth 1 https://github.com/uparrows/luci-theme-atmaterial.git                          # atmaterials 主题（不推荐）

### git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon                                # 重复的Argon主题
### git clone --depth 1 https://github.com/jerrykuku/luci-app-argon-config                           # 重复的Argon主题

git clone --depth 1 https://github.com/gngpp/luci-theme-design.git					                   # 黑暗主题，   针对移动端优化
git clone --depth 1 https://github.com/gngpp/luci-app-design-config.git                                # 黑暗主题设置

git clone --depth 1 https://github.com/thinktip/luci-theme-neobird.git                                 # neobird主题，针对移动端优化
git clone --depth=1 -b openwrt-18.06 https://github.com/rosywrt/luci-theme-rosy                        # rosy玫瑰红主题

### git clone --depth 1 https://github.com/sirpdboy/luci-theme-opentopd                                  # 橙色主题
### git clone --depth 1 https://github.com/kenzok8/luci-theme-ifit ifit && mv -n ifit/luci-theme-ifit ./;rm -rf ifit

### git clone --depth 1 https://github.com/kenzok78/luci-theme-argone
### git clone --depth 1 https://github.com/kenzok78/luci-app-argone-config

# git clone --depth 1 https://github.com/apollo-ng/luci-theme-darkmatter.git
### git clone --depth 1 https://github.com/jenson85/luci-theme-darkmatter.git                          # 下载darkmatter黑暗主题（不显示，无效）
    
#git clone --depth 1 https://github.com/xiaozhuai/luci-app-filebrowser.git    # 英文版   方法：https://www.imethanw.com/notes/openwrt-filebrowser-installation.html
#git clone --depth 1 https://github.com/wangqn/luci-app-filebrowser.git        修改中文版



# 报错，无法编译
#git clone --depth 1 https://github.com/kenzok78/luci-app-filebrowser.git	 # filebrowser网盘 报错
#git clone --depth 1 https://github.com/giaulo/luci-app-filebrowser           # 编译成功后，菜单不显示
# git clone --depth 1 https://github.com/immortalwrt/homeproxy.git           # 家庭代理 报错！！！
# git clone --depth 1 https://github.com/linkease/nas-packages-luci.git && mv -n nas-packages-luci/luci/{luci-app-istorex,luci-app-quickstart} ./; rm -rf nas-packages-luci    # 保留插件：luci-app-istorex + luci-app-quickstart   # 报错！！！
# git clone https://github.com/zzsj0928/luci-app-serverchand.git package/luci-app-serverchand   # 钉钉机器人推送（已弃用）（菜单不显示！！！）
# git clone https://github.com/fangli/openwrt-vm-tools package/otherapp/open-vm-tools                                            ## open-vm-tools 工具；（Utilities--->>open-vm-tools   选择设置为 M 模块化功能）源码自带的有了
# git clone https://github.com/tindy2013/openwrt-subconverter.git                      ## subconverter 订阅转换   不显示
# git clone --depth 1 https://github.com/project-openwrt/openwrt.git package/otherapp/luci-app-diskman                           ## 不显示
#git clone https://github.com/cjbassi/gotop.git package/otherapp/gotop                      # gotop 活动监视器
#git clone https://github.com/xxxserxxx/gotop.git package/otherapp/luci-app-gotop   # gotop 活动监视器
# git clone --depth 1 https://github.com/linkease/nas-packages.git && mv -n nas-packages/network/services/{ddnsto,quickstart} ./; rm -rf nas-packages      # 保留插件：ddnsto + quickstart  菜单不显示！！！）
# git clone --depth 1 https://github.com/linkease/istore.git && mv -n istore/luci/* ./; rm -rf istore taskd   # 保留插件：luci-app-store + luci-lib-taskd + luci-lib-xterm    # 报错！！！
# # mkdir -p istore && mv {luci-app-store,luci-lib-taskd,luci-lib-xterm,taskd} istore      # 三个文件夹移动到istore目录内



# 已删库插件
# git clone https://github.com/tuanqing/install-program package/install-program                  # 下载N1写入包（编译前勾选：Utilities--> install-program）
# git clone https://github.com/Hyy2001X/luci-app-autoupdate package/luci-app-autoupdate          # 在线更新固件插件
# git clone https://github.com/Hyy2001X/luci-app-shutdown package/luci-app-shutdown              # 一键关机/重启
# git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/luci-app-jd-dailybonus     # 京东签到



# lede跟Lienol源码增加luci-app-bypass的话，把以下代码放入diy-1.sh里面就行
# git clone https://github.com/garypang13/luci-app-bypass package/luci-app-bypass
# svn co https://github.com/garypang13/openwrt-packages/trunk/lua-maxminddb
# find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-redir/shadowsocksr-libev-alt/g' {}
# find package/*/ feeds/*/ -maxdepth 2 -path "*luci-app-bypass/Makefile" | xargs -i sed -i 's/shadowsocksr-libev-ssr-server/shadowsocksr-libev-server/g' {}

# Project源码增加luci-app-bypass的话，把以下代码放入diy-1.sh里面就行
# git clone https://github.com/garypang13/luci-app-bypass package/luci-app-bypass
# svn co https://github.com/garypang13/openwrt-packages/trunk/lua-maxminddb



# 单独下载
# 使用方法：git_sparse_clone   openwrt-23.05   "https://github.com/openwrt/openwrt"   "openwrt"    package/base-files   package/network/config/firewall4
#           git_sparse_clone   分支名          仓库地址                               保存文件名   仓库文件路径         保存至本地的路径


# ------------------------------------------------------------------------------------
# sed -i \
# -e 's?include \.\./\.\./\(lang\|devel\)?include $(TOPDIR)/feeds/packages/\1?' \
# -e 's?2. Clash For OpenWRT?3. Applications?' \
# -e 's?\.\./\.\./luci.mk?$(TOPDIR)/feeds/luci/luci.mk?' \
# -e 's/ca-certificates/ca-bundle/' \
# */Makefile


### sed -i 's/luci-lib-ipkg/luci-base/g' luci-app-store/Makefile                                    # 修改：在 luci-app-store/Makefile 文件中，   把 luci-lib-ipkg 命令修改为：   luci-base
### sed -i 's/+dockerd/+dockerd +cgroupfs-mount/' luci-app-docker*/Makefile                         # 添加：在 luci-app-docker*/Makefile 文件中，   +dockerd 命令后添加：   +cgroupfs-mount
### sed -i '$i /etc/init.d/dockerd restart &' luci-app-docker*/root/etc/uci-defaults/*
### sed -i 's/+libcap /+libcap +libcap-bin /' luci-app-openclash/Makefile                           # 添加：在 luci-app-openclash/Makefile 文件中，  +libcap 命令后添加：   +libcap-bin
### sed -i 's/\(+luci-compat\)/\1 +luci-theme-argon/' luci-app-argon-config/Makefile                # 添加：在 luci-app-argon-config/Makefile 文件中，   LUCI_DEPENDS:=+luci-compat 命令后面添加：  +luci-theme-argon 
### sed -i 's/\(+luci-compat\)/\1 +luci-theme-design/' luci-theme-design-config/Makefile                 
### sed -i 's/\(+luci-compat\)/\1 +luci-theme-argone/' luci-app-argone-config/Makefile
#sed -i -e 's/nas/services/g' -e 's/NAS/Services/g' $(grep -rl 'nas\|NAS' luci-app-fileassistant)
### sed -i '/entry({"admin", "nas"}, firstchild(), "NAS", 45).dependent = false/d; s/entry({"admin", "network", "eqos"}, cbi("eqos"), _("EQoS"))/entry({"admin", "network", "eqos"}, cbi("eqos"), _("EQoS"), 121).dependent = true/' luci-app-eqos/luasrc/controller/eqos.lua    # 修改： 在 luci-app-eqos/luasrc/controller/eqos.lua 文件中，  命令修改为 第二个entry后面

#sed -i '65,73d' adguardhome/Makefile
#sed -i '/^\t\$(call Build\/Prepare\/Default)/a \\tif [ -d "$(BUILD_DIR)\/AdGuardHome-$(PKG_VERSION)" ]; then \\\n\t\tmv "$(BUILD_DIR)\/AdGuardHome-$(PKG_VERSION)\/"* "$(BUILD_DIR)\/adguardhome-$(PKG_VERSION)\/"; \\\n\tfi' adguardhome/Makefile
#sed -i '/gzip -dc $(DL_DIR)\/$(FRONTEND_FILE) | $(HOST_TAR) -C $(PKG_BUILD_DIR)\/ $(TAR_OPTIONS)/a \\t( cd "$(BUILD_DIR)\/adguardhome-$(PKG_VERSION)"; go mod tidy )' adguardhome/Makefile
#rm -rf adguardhome/patches
#sed -i '59s/.*/local port=luci.sys.exec("awk \x27\/^dns:\/ {found_dns=1} found_dns \x26\x26 \/\^ port:\/ {print $2; exit}\x27 "..configpath.." 2>nul")/' luci-app-adguardhome/luasrc/model/cbi/AdGuardHome/base.lua

rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore create_acl_for_luci.err create_acl_for_luci.ok create_acl_for_luci.warn      # 删除多余的文件，比如：.git   .gitattributes  .svn    .github   .gitignore
exit 0
