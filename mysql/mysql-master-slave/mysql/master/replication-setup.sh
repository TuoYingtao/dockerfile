#!/bin/bash
# 定义用于同步的用户名
SLAVE_SYNC_USER=${SLAVE_SYNC_USER:-acedia-slave}

# 定义用于同步的用户密码
SLAVE_SYNC_PASSWORD=${SLAVE_SYNC_PASSWORD:-acedia-slave@123}

# 定义用于登录mysql的用户名
ADMIN_USER=${ADMIN_USER:-root}

# 定义用于登录mysql的用户密码
ADMIN_PASSWORD=${MYSQL_ROOT_PASSWORD:-mysql@tuoyingtao.com}

# 定义运行登录的host地址
ALLOW_HOST=${ALLOW_HOST:-%}

# 定义创建账号的sql语句
CREATE_USER_SQL="CREATE USER '$SLAVE_SYNC_USER'@'$ALLOW_HOST' IDENTIFIED BY '$SLAVE_SYNC_PASSWORD';"

# 定义赋予同步账号权限的sql,这里设置两个权限，REPLICATION SLAVE，属于从节点副本的权限，REPLICATION CLIENT是副本客户端的权限，可以执行show master status语句
GRANT_PRIVILEGES_SQL="GRANT REPLICATION SLAVE,REPLICATION CLIENT ON *.* TO '$SLAVE_SYNC_USER'@'$ALLOW_HOST';"

# 定义刷新权限的sql
FLUSH_PRIVILEGES_SQL="FLUSH PRIVILEGES;"

echo "Prepare to create a sync user sql statement： $CREATE_USER_SQL"
echo "Prepare to grant user permissions sql statement： $GRANT_PRIVILEGES_SQL"
echo "start running..."

# 执行sql
mysql -u"$ADMIN_USER" -p"$ADMIN_PASSWORD" -e "$CREATE_USER_SQL $GRANT_PRIVILEGES_SQL $FLUSH_PRIVILEGES_SQL"

echo "end running..."
