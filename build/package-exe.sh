#!/bin/bash
pwd_path=$(pwd)                         ## 赋于成变量= 当前执行目录，

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
# ----------------------------------下载最新版插件，在“main”目录内----------------------------------------------------------------
git clone --depth 1 https://github.com/WangGithubUser/FastGitHub       FastGitHub_加速工具              ## GitHub加速工具              （上传资产）
git clone --depth 1 https://github.com/fhefh2015/Fast-GitHub           Fast-GitHub_加速工具             ## GitHub加速工具
git clone --depth 1 https://github.com/cuifengcn/TAICHI-flet           TAICHI-flet_太极工具箱           ## 太极工具箱
git clone --depth 1 https://github.com/huiyadanli/RevokeMsgPatcher     RevokeMsgPatcher_微信防撤回      ## PC版微信/QQ/TIM防撤回       （上传资产）
git clone --depth 1 https://github.com/truedread/netflix-1080p         netflix-1080p                    ## Netflix-1080P插件           （上传资产）
git clone --depth 1 https://github.com/h2y/Shadowrocket-ADBlock-Rules  Shadowrocket-ADBlock-Rules_广告过滤功能   ## 火箭  屏蔽广告规则
git clone --depth 1 https://github.com/tl-open-source/tl-rtc-file      tl-rtc-file_在线文件传输         ## 开源在线文件传输
git clone --depth 1 https://github.com/baogaichejian/blinker_xiaoai_wendu   blinker_xiaoai_wendu_控制esp8266    ## 点灯科技控制esp8266
git clone --depth 1 https://github.com/chuangmengtech/blinker_xiaoai_wendu   blinker_xiaoai_wendu_esp8266温度传感器          ## esp8266温度传感器
git clone --depth 1 https://github.com/Fatetang/blinker_xiaoai_dengpao-wendu-ESP8266 blinker_xiaoai_dengpao-wendu-ESP8266_ESP8266+继电器  # 点灯科技
git clone --depth 1 https://github.com/esirplayground/VPS_OpenWrt      VPS_OpenWrt                      # 本部署OpenWrt到VPS平台
git clone --depth 1 https://github.com/lollipopkit/flutter_server_box   flutter_server_box_全平台SSH工具 # 全平台SSH工具               （上传资产）
# git clone --depth 1 
# git clone --depth 1 






# ----------------------------------下载仓库最新发布的资产------------------------------------------------------------------------


# sudo apt install jq             ## 需要安装 jp 依赖工具

# 要下载的仓库列表
REPOS=(
    "WangGithubUser/FastGitHub"
    "truedread/netflix-1080p"
    "huiyadanli/RevokeMsgPatcher"
	"lollipopkit/flutter_server_box"
)

# 下载文件保存的指定目录
DOWNLOAD_DIR="$pwd_path/Backups-exe"


# 获取前3个发布的资产并下载
download_latest_releases() {
    local repo=$1
    local api_url="https://api.github.com/repos/$repo/releases"

    echo "获取 $repo 的发布信息..."
    local releases_info=$(curl -s $api_url)
    
    # 检查是否成功获取 release 信息
    if [ $? -ne 0 ]; then
        echo "获取 $repo 的发布信息失败"
        return 1
    fi

    # 获取发布数量
    local release_count=$(echo $releases_info | jq 'length')

    # 处理发布数量不满3个的情况
    local max_releases=3
    if [ $release_count -lt $max_releases ]; then
        max_releases=$release_count
    fi

    # 使用 jq 提取发布的标签名和资产下载 URL
    for i in $(seq 0 $(($max_releases - 1))); do
        local tag_name=$(echo $releases_info | jq -r ".[$i].tag_name")
        local asset_urls=$(echo $releases_info | jq -r ".[$i].assets[].browser_download_url")

        if [ -z "$asset_urls" ]; then
            echo "未找到 $repo 发布的资产。"
            continue
        fi

        # 创建目录以保存下载的文件
        local repo_name="${repo//\//-}-$tag_name"
		local download_path="$DOWNLOAD_DIR/$repo_name"
        mkdir -p $download_path

        for url in $asset_urls; do
            echo "正在下载 $url..."
            curl -L -o "$download_path/$(basename $url)" $url
        done

        echo "已将 $repo 的资产下载到 $download_path"
    done
}

# 遍历所有仓库并下载前3个发布的资产
for repo in "${REPOS[@]}"; do
    download_latest_releases $repo
done



# ----------------------------------收藏的网址------------------------------------------------------------------------------------
# cat <<EOL > Favorite_URL.txt
# http://example1.com
# EOL

content="http://example1.com
http://example12.com
http://example122.com
http://example1222.com
http://example12222.com
http://example122.com"



if [ -f "Favorite_URL.txt" ]; then
    # 文件存在，读取内容并与预定义内容比较
    current_content=$(cat Favorite_URL.txt)
    
    if [ "$current_content" != "$content" ]; then
        # 内容不一致，且文件确实有改动时才覆盖写入
        if ! cmp -s <(echo "$content") Favorite_URL.txt; then
            echo "$content" > Favorite_URL.txt
            echo "内容不一致，已更新文件。"
        fi
    else
        # 内容一致，跳过写操作
        echo "文件内容一致，无需修改。"
    fi
else
    # 文件不存在，创建文件并写入内容
    echo "$content" > Favorite_URL.txt
    echo "文件不存在，已创建并写入内容。"
fi






# # 检查文件是否存在
# if [ -f "Favorite_URL.txt" ]; then
    # # 文件存在，读取内容并与预定义内容比较
    # current_content=$(cat Favorite_URL.txt)
    
    # if [ "$current_content" != "$content" ]; then
        # # 内容不一致，覆盖写入新内容
        # echo "$content" > Favorite_URL.txt
        # echo "内容不一致，已更新文件。"
    # else
        # # 内容一致，跳过写操作
        # echo "文件内容一致，无需修改。"
    # fi
# else
    # # 文件不存在，创建文件并写入内容
    # echo "$content" > Favorite_URL.txt
    # echo "文件不存在，已创建并写入内容。"
# fi



# if [ ! -f "Favorite_URL.txt" ]; then
    # # 文件不存在，创建文件并写入内容
    # echo "$content" > Favorite_URL.txt
# else
    # # 文件存在，检查内容是否一致
    # if ! echo "$content" | sha256sum -c --status <(sha256sum Favorite_URL.txt); then
        # # 如果内容不一致，覆盖写入新内容
        # echo "$content" > Favorite_URL.txt
    # fi
# fi

# --------------------------------------------------------------------------------------------------------------------------------



rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore create_acl_for_luci.err create_acl_for_luci.ok create_acl_for_luci.warn      # 删除多余的文件，比如：.git   .gitattributes  .svn    .github   .gitignore
exit 0
