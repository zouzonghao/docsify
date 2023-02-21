# linux

# 1、Windows上ssh密钥改变

```
Host key for 121.4.87.64 has changed and you have requested strict checking.
Host key verification failed.
```

云服务器重装系统之后，需要清除旧的ssh密钥，windows才能正常使用ssh连接

C盘-》用户-》Administrator（本机账户）-》.ssh-》修改known_hosts

# 2、yum更新

```
yum -y update
升级所有包同时也升级软件和系统内核

yum -y upgrade
只升级所有包，不升级软件和系统内核
```

# 3、安装宝塔面板

Centos安装脚本：https://www.bt.cn/new/download.html

```
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh ed8484bec
```

# 4、docker镜像加速

```
nano /etc/docker/daemon.json
```

```
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
```

# 5、docker 安装

```
# 1、yum 包更新到最新 
yum update

# 2、安装需要的软件包， yum-util 提供yum-config-manager功能，另外两个是devicemapper驱动依赖的 
yum install -y yum-utils device-mapper-persistent-data lvm2

# 3、 设置yum源
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 4、 安装docker，出现输入的界面都按 y 
yum install -y docker-ce

# 5、 查看docker版本，验证是否验证成功
docker -v
```

# 6、Frp内网穿透

## 服务器端：frps

```
# 创建存放目录
sudo mkdir /etc/frp
# 创建frps.ini文件
nano /etc/frp/frps.ini
```

frps.ini内容如下：

```
[common]
# 监听端口
bind_port = 7000
# 面板端口
dashboard_port = 7500
# 登录面板账号设置
dashboard_user = admin
dashboard_pwd = spoto1234
# 设置http及https协议下代理端口（非重要）
vhost_http_port = 7080
vhost_https_port = 7081


# 身份验证
token = 12345678
```

docker安装并运行容器

```
docker run --restart=always --network host -d -v /etc/frp/frps.ini:/etc/frp/frps.ini --name frps snowdreamtech/frps

#服务器镜像：snowdreamtech/frps
#重启：always
#网络模式：host
#文件映射：/etc/frp/frps.ini:/etc/frp/frps.ini
```

## 客户端：frpc

新建文件frpc.ini

```
[common]
# server_addr为FRPS服务器IP地址
server_addr = 121.4.87.64
# server_port为服务端监听端口，bind_port
server_port = 7000
# 身份验证
token = 12345678

[chfs]
type = tcp
local_ip = 192.168.31.3
local_port = 23456
remote_port = 23456

# [ssh] 为服务名称，下方此处设置为，访问frp服务段的2288端口时，等同于通过中转服务器访问127.0.0.1的22端口。
# type 为连接的类型，此处为tcp
# local_ip 为中转客户端实际访问的IP 
# local_port 为目标端口
# remote_port 为远程端口
```

docker安装并运行容器

```
docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc
```

# 7、docker开机启动

```
# 设置开机启动
systemctl enable docker
# 将指定用户添加到用户组
usermod -aG docker root
```

# 8、docker常用命令

1. docker version
显示docker版本信息

2. docker info
显示docker系统信息

3. docker search
从Docker Hub查找镜像
docker search php 查找php的镜像

4. docker images
列出本地镜像

5. docker ps
列出所有在运行的容器信息
docker ps -a 显示所有的容器，包括未运行的

6. docker pull
从镜像仓库中拉取或者更新指定镜像
docker pull codehi/nginx:v1 拉取自己仓库的nginx镜像

​	7 docker start/stop/restart
​		启动/停止/重启容器
​		docker stop mynginx 停止运行中的容器mynginx
​	docker stop `docker ps -a -q` 停止所有容器

8. docker rm
删除一个或多个容器
docker rm mynginx 删除容器mynginx,正在运行中的容器需要stop后才能删除，或者使用强制删除。
docker rm -f mynginx 强制删除运行中的容器mynginx
docker rm `docker ps -a -q` 删除所有容器

9. docker rmi
删除本地一个或多个镜像
docker rmi codehi/nginx:v1 删除镜像codehi/nginx:v1
docker rmi -f codehi/nginx:v1 强制删除
docker rmi `docker images -q` 删除所有镜像

10. docker logs
获取容器的日志
docker logs -f mynginx 跟踪容器mynginx的日志，实时输出的。

11. docker history
查看指定镜像的创建历史
docker history codehi/nginx:v1 查看本地镜像codehi/nginx:v1的创建历史

12. docker login
登陆到一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub
docker login 登录至Docker Hub，下一步会提示输入账号密码

13. docker logout
登出Docker Hub

14. docker push
将本地的镜像上传到镜像仓库,要先登陆到镜像仓库
docker push codehi/nginx:v1 将本地镜像codehi/nginx:v1镜像推送到docker hub仓库中

15. docker commit
从容器创建一个新的镜像
docker commit -a "codehui" -m "test" 3218b3ad4e47 codehi/nginx:v1 3218b3ad4e47 保存为新的镜像codehi/nginx:v1,并添加提交人信息(codehui)和说明信息(test)

16. docker tag
标记本地镜像，将其归入某一仓库
docker tag nginx:v1 codehi/nginx:v2 将镜像nginx:v1标记为 codehi/nginx:v2 镜像

17. docker save
将指定镜像保存成 tar 归档文件
docker save -o codehi-nginx-v1.tar codehi/nginx:v1 将镜像codehi/nginx:v1生成codehi-nginx-v1.tar归档文件

18. docker load
从归档文件中创建镜像
docker load -i codehi-nginx-v1.tar 从镜像归档文件codehi-nginx-v1.tar创建镜像

19. docker export
将文件系统作为一个tar归档文件导出到STDOUT
docker export -o codehi-nginx-v1.tar mynginx 将容器mynginx保存为tar文件。

20. docker import
从归档文件中创建镜像
docker import codehi-nginx-v1.tar codehi-nginx-v1 从镜像归档文件codehi-nginx-v1.tar创建镜像，命名为codehi-nginx-v1

21. docker kill
杀掉一个运行中的容器
docker kill -s KILL mynginx 杀掉运行中的容器mynginx

# 9、code-server

安装脚本

```
curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
```

# 10、Clash

https://blog.iswiftai.com/posts/clash-linux/#%E4%BD%BF%E7%94%A8%E4%BB%A3%E7%90%86

1、下载3样，并上传到/root/clash

1.clash-https://github.com/Dreamacro/clash/releases

2.country.mmdb-https://github.com/Dreamacro/maxmind-geoip/releases

（下载不到，第一次运行clash会自动生成至 `/home(root)/XXX/.config/clash` 文件夹下）

3.config.yaml-从别处导入

2、使用 `gunzip` 命令解压，并重命名为 `clash`

```
cd /root/clash
gunzip clash-linux-amd64-v1.10.0.gz
mv clash-linux-amd64-v1.10.0 clash
```

3,为clash添加权限

```
chmod u+x clash
```

4、拷贝到

```
sudo mkdir /etc/clash
sudo cp clash /usr/local/bin
sudo cp config.yaml /etc/clash/
sudo cp Country.mmdb /etc/clash/
```

5、创建 systemd 服务配置文件 

```
sudo nano /etc/systemd/system/clash.service
```

```
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/clash -d /etc/clash

[Install]
WantedBy=multi-user.target
```

ctrl + c -》y-》回车

6、使用 systemctl

使用以下命令，让 Clash 开机自启动：

```
sudo systemctl enable clash 
```

然后开启 Clash：

```
sudo systemctl start clash 
```

查看 Clash 日志：

```
sudo systemctl status 
clash sudo journalctl -xe
```

# 11、DDNS-go

```
docker run -d --name ddns-go --restart=always --net=host jeessy/ddns-go
```
```
docker run -d --name ddns-go --restart=always -p 9876:9876 -v /Users/macm2/Desktop/docker/ddns-go:/root jeessy/ddns-go
```
- 在浏览器中打开`http://主机IP:9876`，修改你的配置，成功

# 12、filebrowser

```
docker run   -d --restart=always\
    -v /docker/filebrowser:/srv \
    -p 12345:80 \
	--name filebrowser \
    filebrowser/filebrowser
```

在浏览器中打开`http://主机IP:12345`，修改你的配置，成功

# 13、ZSH

1、安装zsh

如果你用 Redhat Linux，执行：

```
sudo yum install zsh
```

如果你用 Ubuntu Linux，执行：

```
sudo apt-get install zsh
```

安装完成后设置当前用户使用 zsh：

```
chsh -s /bin/zsh
```

安装git

自动安装：

```text
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

2、主题

```
# 拉取项目仓库，可以通过上面提到的方法进行加速，此处直接放镜像地址，如果因为时间问题镜像失效，请使用其github官方地址
git clone https://gitee.com/xiaoqqya/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

# 添加软链接
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 

# 更改主题，按照上面提到的方法在.zshrc配置中修改ZSH_THEME变量为spaceship，然后重启终端生效
```

保存后重开终端或者执行`exec $SHELL`命令即可生效

3、插件

```
# 拉取项目仓库，可以通过上面提到的方法进行加速，此处直接放镜像地址，如果因为时间问题镜像失效，请使用其github官方地址
git clone https://gitee.com/xiaoqqya/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# 启用插件，按照上面提到的方法在.zshrc配置的plugins中加入zsh-autosuggestions，然后重启终端生效
```

```
# 拉取项目仓库，可以通过上面提到的方法进行加速，此处直接放镜像地址，如果因为时间问题镜像失效，请使用其github官方地址
git clone https://gitee.com/xiaoqqya/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 启用插件，按照上面提到的方法在.zshrc配置的plugins中加入zsh-syntax-highlighting，然后重启终端生效
```

pip

docker

docker-compose

一条`extract`命令解压多种压缩包格式，使用方法如下：

command-not-found

# 14、SMB

```
apt install smaba
```

```
nano /etc/samba/smb.conf 
```

在最后添加

```
[share]
    path = /home/share
    available = yes
    browseable = yes
    public = yes
    writable = yes
```

```
systemctl restart smbd
```

# 15、WOL

查看网口名和MAC地址

```
ifconfig
```

创建wol服务脚本

```
nano /etc/systemd/system/wol.service
```

输入一下内容：修改eno1为自己设备的网卡名

```
[Unit]
Description=Configure Wake On LAN
[Service]
Type=oneshot
ExecStart=/sbin/ethtool -s eno1 wol g   
[Install]
WantedBy=basic.target
```

设置开机自启

```
systemctl enable wol.service
systemctl start wol.service
```

下载远程唤醒app，输入MAC地址，即可

# 16、利用优选CDN加速内网穿透

![](https://a.sanqi.one/chfs/shared/%E7%85%A7%E7%89%87/IMG20220620174301.jpg)



# 17、目录含义和用途

- /
  - Linux的根目录，一台电脑有且只有一个根目录，所有的文件都是从这里开始的。举个例子：当你在终端里输入“/home”，你其实是在告诉电脑，先从/（根目录）开始，再进入到home目录。
- bin 和 /usr/bin
  - 大部分系统命令都以机器可读格式保存为二进制文件。一般用户使用的命令通常位于二进制目录`/bin`或`/usr/bin`中。系统必需的核心工具命令如`ls, cd, cp, mv`和文本编辑器`vi`都位于目录`/bin`中。辅助工具如编译器、网页浏览器和办公软件位于目录`/usr/bin`中，这些目录下的工具也可以通过网络共享给其他系统上的用户使用。我们可以将`/bin`和`/usr/bin`当成**非特权命令目录**，因为用户不需要有任何特权就可以使用其中的命令。
- boot
  - 目录中存放Ubuntu内核文件及引导加载器bootstraploade相关的文件，如果这个目录中的文件被破坏，一般都会出现启动引导异常，无法正常进入系统。root权限才能读写文件
- dev
  - 该目录包含了Linux系统中使用的所有外部设备，如设备,声卡、磁盘等，还有如`/dev/null.` `/dev/console` `/dev/zero` `/dev/full` 等。它实际上是访问这些外部设备的端口，访问这些外部设备与访问一个文件或一个目录没有区别。
- etc
  - 程序的配置文件目录，Linux 系统的特点之一是它的灵活性。通过修改配置文件，可以控制系统的任何方面。配置文件一般保存在配置目录`/etc`或它的子目录中。例如，系统启动脚本位于`/etc/rc.d`,网络配置文件位于目录`/etc/sysconfig`中。
- home
  - 用户主目录，这里主要存放你的个人数据。具体每个用户的设置文件，用户的桌面文件夹，还有用户的数据都放在这里。每个用户都有自己的用户目录，位置为：`/home/用户名`。当然，root用户除外。 用户主目录显著的作用是作为私人数据空间，他们可以用这个空间把他们的文件与其他用户的文件分开保存。因为每个用户都有自己的空间，所以两个用户可以将文件或目录取同样的名字而不会出现问题。用户主目录的另一个显著作用是保存用户特有的配置文件。
- lib
  - 动态链接共享库文件存放地。bin和sbin需要的库文件。类似windows的DLL。几乎所有的应用程序都会用到该目录下的共享库。
- mnt
  - 临时将别的文件系统挂在该目录下。这个目录一般是用于存放挂载储存设备的挂载目录的。
- opt
  - 这里主要存放一些可选的程序。第三方软件在安装时默认会找这个目录，安装到/opt目录下的程序，它所有的数据、库文件等等都是放在同个目录下面。
- proc
  - 这是process的缩写，表示进程。存放的是系统信息和进程信息。可以在该目录下获取系统信息，这些信息是在内存中由系统自己产生的，操作系统运行时，进程（正在运行中的程序）信息及内核信息（比如cpu、硬盘分区、内存信息等）存放在这里。该目录的内容不在硬盘上而在内存里。
- root
  - 系统管理员（root user）的目录。超级管理员拥有最高级的权限，能够对系统中的几乎所有文件系统可读可写可执行的操作。
- sbin 和 /usr/sbin
  - 就如同`/bin 和 /usr/bin` 为一般用户保存命令文件一样，它们也为超级用户（根用户）保存命令文件。其中包括安装和删除硬件、启动和关闭系统以及进行系统维护的命令。和上面提到的将命令分别存放与`/bin` 和 `/usr/bin` 的原因一样，这些`特权命令`也是分别保存在两个目录中。
- tmp
  - 用来存放不同程序执行时产生的临时文件，一般系统重启不会被保存
- usr
  - 用户的应用程序和文件几乎都存放在该目录下,在这个目录下，你可以找到那些不适合放在`/bin`或`/etc`目录下的额外的工具。比如像游戏阿，一些打印工具等等。`/usr`目录包含了许多子目录： `/usr/bin`目录用于存放程序；`/usr/share`用于存放一些共享的数据，比如音乐文件或者图标等等；`/usr/lib`目录用于存放那些不能直接运行的，但却是许多程序运行所必需的一些函数库文件。你的软件包管理器会自动帮你管理好`/usr`目录的。
- var
  - 存放内容经常变化的文件和目录。例如日志，电子邮件，网站，ftp归档文件等。将这些文件放在这里便于给它们分配空间，同时也保护系统里其他比较稳定的文件。

# 18、新建服务

1，新建服务文件
每一个服务在Linux有它自己的对应的配置文件，这个文件可以通过文本编辑器编辑，扩展名为xxx.servive（xxx为服务名称）。这些文件位于`/etc/systemd/system`目录下。

在这个目录下新建service文件即可创建我们的服务。文件的内容结构如下：

```
[Unit]
Description=服务描述
After=服务依赖（再这些服务后启动本服务）

[Service]
Type=服务类型
ExecStart=启动命令
ExecStop=终止命令
ExecReload=重启命令

[Install]
WantedBy=服务安装设置
```

可见服务配置文件分为[Unit]、[Service]和[Install]三大部分。

一般来说有些值是固定的，没有特殊需要我们直接套用即可。例如[Unit]中After的值一般是：network.target remote-fs.target nss-lookup.target。

[Install]的WantedBy一般是multi-user.target。

[Service]中是主要内容。

Type的值有以下几个：

simple：这是默认的值，指定了ExecStart设置后，simple就是默认的Type设置除非指定Type。simple使用ExecStart创建的进程作为服务的主进程，在此设置下systemd会立即启动服务。
forking：如果使用了这个值，则ExecStart的脚本启动后会调用fork()函数创建一个进程作为其启动的一部分。当初始化完成，父进程会退出。子进程会继续作为主进程执行。
oneshot：类似simple，但是在systemd启动之前，进程就会退出。这是一次性的行为。可能还需要设置RemainAfterExit=yes，以便systemd认为j进程退出后仍然处于激活状态。
dbus：也和simple很相似，该配置期待或设置一个name值，通过设置BusName=设置name即可。
notify：同样地，与simple相似的配置。顾名思义，该设置会在守护进程启动的时候发送推送消息。
其实常用的就是simple和forking了。一般来说我们的程序是应用程序前台使用就用simple，后台/守护进程一般是forking。

然后就是启动/停止/重启命令，注意这个命令里面调用的程序必须全部使用绝对路径。

例如，我的服务器上的redis的Service配置：

```
[Unit]
Description=Redis-Server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/opt/Redis-6.2.1/redis-server /root/RedisData/redis-conf.conf
ExecStop=kill -9 $(pidof redis-server)
ExecReload=kill -9 $(pidof redis-server) && /opt/Redis-6.2.1/redis-server /root/RedisData/redis-conf.conf

[Install]
WantedBy=multi-user.target
```

因为redis一般作为后台程序运行所以Type填forking。kill -9 $(pidof redis-server)命令的意思是：先用pidof命令获取指定名称进程的pid再把这个结果传给kill命令终止对应进程。平时终止特定名称的进程时也可以这么写。

其实除此之外，service文件还有很多配置项，这里只写出了常用必要的，满足日常需求，其余可以自行搜索学习，这里不再过多赘述。

2，启动/停止/重启我们的服务
刚刚建立好了我们的服务配置，现在就可以使用了！在此之前需要先使用下列命令让系统重新读取所有服务文件：

```
systemctl daemon-reload
```

然后通过以下命令操控服务：

启动服务

```
service 服务名 start
```

终止服务

```
service 服务名 stop
```

重启服务

```
service 服务名 restart
```

那么注意服务名就是我们刚刚创建的服务配置文件service文件的文件名（不包括扩展名），例如我的服务文件是redis-server.service，那么我的服务名是redis-server。

其实我们执行启动服务命令时，就会执行我们刚刚配置文件中ExecStart的值的命令，同样终止、重启会对应执行配置文件中ExecStop、ExecReload的值的命令。

3，启用/禁用开机自启
通过以下命令启用/禁用开机自启动：

启用开机自启

```
systemctl enable 服务名
```

禁用开机自启

```
systemctl disable 服务名
```

# 19、Syncthing

https://apt.syncthing.net/

安装完后修改配置文件

```
/root/.config/syncthing/config.xml
```

把监听地址改成0.0.0.0:8384

```
http://192.3.128.27:8384/#
root
admin
```



# 20、minimalist-web-notepad

```
docker run -d  --restart=always --name web-notepad -v /docker/filebrowser/text:/var/www/html/_tmp -p 12346:80 jdreinhardt/minimalist-web-notepad:latest
```

# 21、kplayer

https://docs.kplayer.net/v0.5.7/overview/

```
windows
docker run -d  --restart=always --name kplayer -v /D/kplayer/config:/kplayer -v /D/kplayer/video:/home/user/video  -p 4156:4156 -p 4157:4157 bytelang/kplayer:latest
```

```
mac
docker run -d  --restart=always --name kplayer -v /Users/macm2/Desktop/kplayer:/kplayer -v /Users/macm2/Desktop/services/filebrowser/root:/home/user/video  -p 4156:4156 -p 4157:4157 bytelang/kplayer:latest
```

```json
{
    "version": "2.0.0",
    "resource": {
        "lists": [
            "/home/user/video/test.mp4"
        ]
    },
    "output": {
        "lists": [
            {
                "path": "rtmp://live-push.bilivideo.com/live-bvc/?streamname=live_102957727_68460487&key=0689944babe2c048ec027959a43097ec&schedule=rtmp&pflag=1"
            }                                                    
        ]
    },
	"play": {
    
    "encode": {
    "start_point": 1,
    "play_model": "list",
    "cache_on": true,
    "cache_uncheck": false,
    "skip_invalid_resource": true,
    "fill_strategy": "ratio",
    "rpc": {
      "on": true,
      "http_port": 4156,
      "grpc_port": 4157,
      "address": "0.0.0.0"
    },
	
      "video_width": 3840,
      "video_height": 2160,
      "video_fps": 30
      
    }
  }
}
```



# 22、scp



```
scp 文件名 用户名@服务器ip:目标路径
scp -r 文件夹目录 用户名@服务器ip:目标路径
```

# 23、docsify

https://docsify.js.org/#/zh-cn/

Index.html

```html
!DOCTYPE html>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta charset="UTF-8">
  <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/docsify/themes/vue.css">
</head>
<body>
  <div id="app"></div>
  <script>
    window.$docsify = {
        loadSidebar: true,
        subMaxLevel: 2
    }
  </script>
  <script src="//cdn.jsdelivr.net/npm/docsify/lib/docsify.min.js"></script>
</body>
</html>
```

侧边栏：

_sidebar.md

```
* [首页](/)
* [计算机]()
    * [linux](/计算机/linux)
```

自动找readme.md



Voce chat

docker 

Iterm2 ok

joplin



markdown+git +docsify

# 24、git

Mac git 脚本：

```shell
#!/bin/bash
cd /Users/macm2/Desktop/sanqiz37
git status
echo "####### 开始自动Git #######"
current_time=$(date "+%Y/%m/%d -%H:%M:%S") # 获取当前时间
echo ${current_time} # 显示当前时间
git add .
git commit -m "modified ${current_time}" # 远程仓库可以看到是什么时间修改的...
git push 
echo "####### 自动Git完成 #######"
sleep 2
```

## 一个本地，多个远程

## github token

**1.github在2021年8月14日七夕这天搞事情，如果这天你提交了github代码报错如下**：

问题：remote: Support for password authentication was removed on August 13, 2021. Please use a personal access token instead.
![](:/84d0db463633436b86b8fbc9b29070b6)

 大概意思就是`你原先的密码凭证从2021年8月13日`开始就不能用了，`必须使用个人访问令牌（personal access token）`，就是把你的`密码`替换成`token`！

**2.为什么要把密码换成token**

**2.1 修改为token的好处**

令牌（token）与基于密码的身份验证相比，令牌提供了许多安全优势：

唯一： 令牌特定于 [GitHub](https://so.csdn.net/so/search?q=GitHub&spm=1001.2101.3001.7020)，可以按使用或按设备生成

可撤销：可以随时单独撤销令牌，而无需更新未受影响的凭据

有限 ： 令牌可以缩小范围以仅允许用例所需的访问

随机：令牌不需要记住或定期输入的更简单密码可能会受到的字典类型或蛮力尝试的影响

**2.2 如何生成自己的token**

登录自己的github账号，个人设置那里

![](:/c357d5fba5ff4847874825a7b7de5264)

** 2.3 选择开发者设置 `Developer setting`**

![](:/6a9d65ec1261489fab03a5e8160b0568)

** 2.4 选择个人访问令牌 `Personal access tokens`，然后选中生成令牌 `Generate new token`**

![](:/71089395a6f04902b87e8fbb0f62c2e8)

**2.5 设置token的有效期，访问权限等**

选择要授予此`令牌token`的`范围`或`权限`。

- 要使用`token`从命令行访问仓库，请选择`repo`。
- 要使用`token`从命令行删除仓库，请选择`delete_repo`
- 其他根据需要进行勾选

![](:/04f4464d28064c49adf50c5c3b05e6c7)**2.6  最后生成令牌 `Generate token`**

![](:/fc798dd2d9cf4c2092f7d05b3c223b80)

** 2.7 生成后的token如下：**

![](:/271e3904bf674cb09b95ecc3f065817e)

**`注意：`**

记得把你的**token**保存下来，因为你再次刷新网页的时候，你已经没有办法看到它了，所以我还没有彻底搞清楚这个**`token`**的使用，后续还会继续探索！

**3\. 之后用自己生成的`token`登录，把上面生成的`token`粘贴到`输入密码的位置`，然后成功push代码！**

**也可以 把token直接添加远程仓库链接中，这样就可以避免同一个仓库每次提交代码都要输入token了：**

**git remote set-url origin https://&lt;your_token&gt;@github.com/&lt;USERNAME&gt;/&lt;REPO&gt;.git**

**&lt;your_token&gt;：换成你自己得到的token
&lt;USERNAME&gt;：是你自己github的用户名
&lt;REPO&gt;：是你的仓库名称**

**例如：（全局设置某一个仓库的 token）以后每次提交都不需要账户和密码了**

 git remote set-url origin https://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@github.com/**github的用户名**/**仓库名称**.git

最后提交 直接输入： git push     

就不用输入账户和密码了。
