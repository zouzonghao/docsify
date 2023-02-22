# mac

# 1、utool

通过插件快速打开运行

# 2、快捷键

显示隐藏文件 command + Shift + .

# 3、文件已损坏！

```
sudo xattr -d com.apple.quarantine <应用路径>
```

# 4、filebrowser

添加脚本

startup.sh

```
#!/bin/bash

cd /Users/macm2/Desktop/services/filebrowser
nohup ./filebrowser &


```

