#!/bin/bash
set -e

# 查看mysql服务的状态，方便调试，这条语句可以删除
echo `service mysql status`

echo '1.启动mysql....'
# 启动mysql
service mysql start
sleep 3

echo `service mysql status`

# 建库与角色权限
echo '2.建库与角色权限....'
mysql < /mysql/privileges.sql
sleep 3
echo '2-1.建库与角色权限完毕....'

# 导入数据
echo '3.whale-tik-cloud 库开始导入数据表结构....'
mysql < /mysql/whale-tik-cloud.sql
echo '3-1.whale-tik-cloud 库导入数据完毕....'

# sleep 3
echo `service mysql status`
echo `mysql容器启动完毕,且数据导入成功`

tail -f /dev/null
