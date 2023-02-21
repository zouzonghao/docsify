#!/bin/zsh
git status
echo "####### 开始自动Git #######"
current_time=$(date "+%Y/%m/%d -%H:%M:%S") # 获取当前时间
echo ${current_time} # 显示当前时间
git add .
git commit -m "modified ${current_time}" # 远程仓库可以看到是什么时间修改的...
git push 
echo "####### 自动Git完成 #######"
sleep 2s 