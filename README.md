# qinglong-wsl
在Windows的wsl(linux子系统)环境安装青龙面板，主要是解决云服务器安装了Windows server无法使用docker的情况  
仅支持Windows server 2019+，需要开启WSL功能  
https://learn.microsoft.com/zh-cn/windows/wsl/install-on-server  
之后到https://www.alpinelinux.org/downloads/根据自己系统选择下载MINI ROOT FILESYSTEM文件  
下载完成后使用wsl命令导入wsl子系统  
wsl --import qinglong C:\qinglong .\alpine.tar  
#wsl --import wsl名称 路径 下载好的MINI ROOT FILESYSTEM文件名  
运行install.sh即可  
