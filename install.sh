sed -i "s@https://dl-cdn.alpinelinux.org/@http://repo.huaweicloud.com/@g" //etc/apk/repositories
apk update --no-cache
apk add --no-cache vim bash coreutils moreutils git curl wget tzdata perl openssl nginx jq openssh py3-pip  python3 
apk add --no-cache --virtual .build-deps-full binutils-gold g++ gcc gnupg libgcc linux-headers make
pip3 config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple
pip3 install lxml requests
sed -i "3i WORKDIR=/ql" /etc/profile
sed -i "3i QL_DIR=/ql" /etc/profile
echo  "PS1=\"\u@\h:\w \$ \" " >> /etc/profile
sed -i "3i SHELL=/bin/bash" /etc/profile
sed -i "3i LANG=zh_CN.UTF-8" /etc/profile
sed -i "3i QL_BRANCH=develop" /etc/profile
sed -i "3i QL_URL=https://github.com/whyour/qinglong.git" /etc/profile
sed -i "3i maintainer=whyour" /etc/profile
sed -i "3i QL_MAINTAINER=whyour" /etc/profile
source /etc/profile
rm -rf /var/cache/apk/*
read -p "请输入需要安装的nodejs版本" node_version
if [ -z "$node_version" ]
then
	node_version=18.10.0
else
	node_version=$node_version
fi
wget -P /root/ https://unofficial-builds.nodejs.org/download/release/v$node_version/node-v$node_version-linux-x64-musl.tar.xz -O node-musl.tar.xz
tar -xJf /root/node-musl.tar.xz -C /usr/local --strip-components=1 --no-same-owner
ln -s /usr/local/bin/node /usr/local/bin/nodejs
ln -s /usr/local/bin/node /usr/bin/node
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
npm cache clean -f
npm config set registry https://repo.huaweicloud.com/repository/npm/
rm -rf /root/.pnpm-store
rm -rf /root/.local/share/pnpm/store
rm -rf /root/.cache
rm -rf /root/.npm 
npm install pnpm -g
git config --global user.email "qinglong@@users.noreply.github.com"
git config --global user.name "qinglong"
git config --global http.postBuffer 524288000
pnpm setup
source ~/.bashrc
pnpm install -g pm2 ts-node typescript tslib @types/node@"*"  
cd /
read -p "请输入需要安装的青龙版本" ql
if [ -z "$ql" ]
then
	ql_version=develop
else
	ql_version=v$ql
fi
git clone -b $ql_version http://vasonhsueh.ml:5701/https://github.com/whyour/qinglong.git
mv qinglong ql
cd ql
cp -f .env.example .env
chmod 777 ${QL_DIR}/shell/*.sh
chmod 777 ${QL_DIR}/docker/*.sh
git clone http://vasonhsueh.ml:5701/https://github.com/whyour/qinglong-static.git
mv qinglong-static static
sed -i "2i QL_DIR=/ql" /ql/shell/*.sh
pnpm install --prod
pnpm install 
rm -rf api
rm -rf bot
rm -rf check
rm -rf notify
rm -rf rmlog
rm -rf ql
rm -rf share
rm -rf task
ln -s /ql/shell/bot.sh /usr/local/bin/bot
ln -s /ql/shell/check.sh /usr/local/bin/check
ln -s /ql/shell/notify.sh /usr/local/bin/notify
ln -s /ql/shell/share.sh /usr/local/bin/share
ln -s /ql/shell/task.sh /usr/local/bin/task
ln -s /ql/shell/rmlog.sh /usr/local/bin/rmlog
ln -s /ql/shell/update.sh /usr/local/bin/ql
ln -s /ql/shell/api.sh /usr/local/bin/api
bash /ql/docker/docker-entrypoint.sh