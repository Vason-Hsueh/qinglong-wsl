read -p "请输入需要安装的nodejs版本,默认18.10.0" node_version
if [ -z "$node_version" ]
then
	node_version=18.10.0
else
	node_version=$node_version
fi
read -p "请输入需要安装的青龙版本,默认最新版本" ql
if [ -z "$ql" ]
then
	ql_version=develop
else
	ql_version=v$ql
fi
echo "[network]" > /etc/wsl.conf
echo "generateResolvConf = false" >> /etc/wsl.conf
cat /etc/resolv.conf > /etc/resolv.conf.bak
rm -rf /etc/resolv.conf
sed -i '1,3d' /etc/resolv.conf.bak
sed -i '3d' /etc/resolv.conf.bak
cp /etc/resolv.conf.bak /etc/resolv.conf
sed -i "s@https://dl-cdn.alpinelinux.org/@https://mirrors.aliyun.com/@g" //etc/apk/repositories
apk update --no-cache
apk add --no-cache vim bash coreutils moreutils git curl wget tzdata perl openssl nginx jq openssh py3-pip  python3  gcc 
pip3 config set global.index-url https://mirrors.aliyun.com/repository/pypi/simple
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
wget https://unofficial-builds.nodejs.org/download/release/v$node_version/node-v$node_version-linux-x64-musl.tar.xz -O ~/node-musl.tar.xz
tar -xJf ~/node-musl.tar.xz -C /usr/local --strip-components=1 --no-same-owner
ln -s /usr/local/bin/node /usr/local/bin/nodejs
ln -s /usr/local/bin/node /usr/bin/node
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
rm /root/node-musl.tar.xz
echo "Asia/Shanghai" > /etc/timezone
npm cache clean -f
npm config set registry http://registry.npmmirror.com
rm -rf /root/.pnpm-store
rm -rf /root/.local/share/pnpm/store
rm -rf /root/.cache
rm -rf /root/.npm 
npm install pnpm -g
pnpm setup
source ~/.bashrc
pnpm install -g pm2 ts-node typescript tslib @types/node@"*"  
cd /
git clone -b $ql_version https://github.com/whyour/qinglong.git
mv qinglong ql
cd ql
cp -f .env.example .env
chmod 777 ${QL_DIR}/shell/*.sh
chmod 777 ${QL_DIR}/docker/*.sh
git clone https://github.com/whyour/qinglong-static.git
mv qinglong-static static
sed -i "2i QL_DIR=/ql" /ql/shell/*.sh
pnpm install
rm -rf /usr/local/bin/bot
rm -rf /usr/local/bin/check
rm -rf /usr/local/bin/notify
rm -rf /usr/local/bin/share
rm -rf /usr/local/bin/task
rm -rf /usr/local/bin/rmlog
rm -rf /usr/local/bin/ql
rm -rf /usr/local/bin/api
ln -s /ql/shell/bot.sh /usr/local/bin/bot
ln -s /ql/shell/check.sh /usr/local/bin/check
ln -s /ql/shell/notify.sh /usr/local/bin/notify
ln -s /ql/shell/share.sh /usr/local/bin/share
ln -s /ql/shell/task.sh /usr/local/bin/task
ln -s /ql/shell/rmlog.sh /usr/local/bin/rmlog
ln -s /ql/shell/update.sh /usr/local/bin/ql
ln -s /ql/shell/api.sh /usr/local/bin/api
bash /ql/docker/docker-entrypoint.sh
