#!/bin/bash
function git_sparse_clone() {
branch="$1" rurl="$2" localdir="$3" && shift 3
git clone -b $branch --depth 1 --filter=blob:none --sparse $rurl $localdir
cd $localdir
git sparse-checkout init --cone
git sparse-checkout set $@
mv -n $@ ../
cd ..
rm -rf $localdir
}

function mvdir() {
mv -n `find $1/* -maxdepth 0 -type d` ./
rm -rf $1
}




git clone --depth 1 https://github.com/gngpp/luci-theme-design.git					                   # 黑暗主题，   针对移动端优化
git clone --depth 1 https://github.com/gngpp/luci-app-design-config.git                                # 黑暗主题设置












rm -rf ./*/.git ./*/.gitattributes ./*/.svn ./*/.github ./*/.gitignore create_acl_for_luci.err create_acl_for_luci.ok create_acl_for_luci.warn      # 删除多余的文件，比如：.git   .gitattributes  .svn    .github   .gitignore
exit 0
