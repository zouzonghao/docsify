# windows

# 1、win11专业版

专业版序列号

```
VK7JG-NPHTM-C97JM-9MPGT-3V66T
```

激活脚本

```shell
irm https://massgrave.dev/get | iex
```

# 2、chrome

```
$Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "http://dl.google.com/chrome/install/375.126/chrome_installer.exe" -OutFile $Path\$Installer; Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path\$Installer
```

# 3、filebrowser

- 下载

- 放到目标文件夹，先运行一次生成配置文件

- "C:\Program Files\filebrowser.exe" config export "C:\Program Files\filebrowser.json"

- 修改filebrowser.json（"root": "D:\\share",）

- "C:\Program Files\filebrowser.exe" config import "C:\Program Files\filebrowser.json"

- 1.下载
  NSSM官方网址：http://www.nssm.cc/download
  2.注册服务
  打开cmd，cd到nssm.exe目录下，使用下面命令
  注册服务使用如下命令： nssm install
  会出现该界面：
  参数填完后执行"install service"按钮即可将服务安装到系统，可以使用系统的服务管理工具services.msc查看了。

  






























1、性能问题

压住140w  cpz 13300

爆发170w  cpz 14000

没办法降压

2、噪音



















