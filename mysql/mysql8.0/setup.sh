#!/bin/bash
set -e

echo '--------------- 查看mysql工具 ---------------'
echo `ls -l /usr/bin/my*`

# 查看mysql服务的状态，方便调试，这条语句可以删除
echo `service mysql status`

echo '--------------- 启动mysql ---------------'
# 启动mysql
service mysql start
sleep 3

echo `service mysql status`

# 建库与角色权限
echo '--------------- 查看配置变量 ---------------'
mysql < SHOW VARIABLES
sleep 2
echo '--------------- 查看配置变量完毕 ---------------'

# 建库与角色权限
echo '--------------- 建库与角色权限 ---------------'
mysql < /mysql/privileges.sql
sleep 3
echo '--------------- 建库与角色权限完毕 ---------------'

# 导入数据
echo '--------------- 库开始导入数据表结构 ---------------'
#mysql < /mysql/xxx.sql
echo '--------------- 库导入数据完毕 ---------------'

# sleep 3
echo `service mysql status`
echo `mysql容器启动完毕,且数据导入成功`

tail -f /dev/null
