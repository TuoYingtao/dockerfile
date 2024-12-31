#!/bin/bash
# 定义连接master进行同步的账号
SLAVE_SYNC_USER="${SLAVE_SYNC_USER:-acedia-slave}"

# 定义连接master进行同步的账号密码
SLAVE_SYNC_PASSWORD="${SLAVE_SYNC_PASSWORD:-acedia-slave@123}"

# 定义slave数据库账号
ADMIN_USER="${ADMIN_USER:-root}"

# 定义slave数据库密码
ADMIN_PASSWORD="${MYSQL_ROOT_PASSWORD:-mysql@tuoyingtao.com}"

# 定义连接master数据库host地址
MASTER_HOST="${MASTER_HOST:-%}"

echo "Wait 10 seconds to ensure that the master database starts successfully, otherwise the connection will fail."

# 等待10s，保证master数据库启动成功，不然会连接失败
sleep 10

# 连接master数据库，查询二进制数据，并解析出logfile和pos，这里同步用户要开启 REPLICATION CLIENT权限，才能使用SHOW MASTER STATUS;
RESULT=`mysql -u"$SLAVE_SYNC_USER" -h$MASTER_HOST -p"$SLAVE_SYNC_PASSWORD" -e "SHOW MASTER STATUS;" | grep -v grep |tail -n +2| awk '{print $1,$2}'`

echo "Connect to the master database, query the binary data, and parse out the logfile and pos. Here, the synchronization user must enable the REPLICATION CLIENT permission to use SHOW MASTER STATUS：$RESULT"

# 解析出logfile
LOG_FILE_NAME=`echo $RESULT | grep -v grep | awk '{print $1}'`

echo "Parse out logfile：$LOG_FILE_NAME"

# 解析出pos
LOG_FILE_POS=`echo $RESULT | grep -v grep | awk '{print $2}'`

echo "Parse out pos：$LOG_FILE_POS"

# 设置连接master的同步相关信息
SYNC_SQL="change master to master_host='$MASTER_HOST',master_user='$SLAVE_SYNC_USER',master_password='$SLAVE_SYNC_PASSWORD',master_log_file='$LOG_FILE_NAME',master_log_pos=$LOG_FILE_POS;"

echo "Set synchronization related information to connect to the master：$SYNC_SQL"

# 开启同步
START_SYNC_SQL="start slave;"

echo "Turn on sync：$START_SYNC_SQL"

# 查看同步状态
STATUS_SQL="show slave status\G;"

echo "View sync status: $STATUS_SQL"
echo "start running..."

mysql -u"$ADMIN_USER" -p"$ADMIN_PASSWORD" -e "$SYNC_SQL $START_SYNC_SQL $STATUS_SQL"

echo "end running..."
