### MySQL - 主从同步

```shell
docker-compose -f docker-compose.yml -p acedia-mysql-db-master -p acedia-mysql-db-slave-backup up -d
```

```shell
# ================== ↓↓↓↓↓↓ 配置主库 ↓↓↓↓↓↓ ==================
# 1.进入主库
docker exec -it acedia-mysql-db-master /bin/bash
# 2.登录mysql
mysql -uroot -p
# 3.创建用户acedia-slave，密码acedia-slave@123
CREATE USER 'acedia-slave'@'%' IDENTIFIED BY 'acedia-slave@123';
# 4.授予slave用户 `REPLICATION SLAVE`权限和`REPLICATION CLIENT`权限，用于在`主` `从` 数据库之间同步数据
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'acedia-slave'@'%';
# GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'acedia-slave'@'%' IDENTIFIED BY 'acedia-slave@123';
# 授予所有权限则执行命令: GRANT ALL PRIVILEGES ON *.* TO 'slave'@'%';
# 5.使操作生效
FLUSH PRIVILEGES;
# 6.查看状态
show master status;
# 注：File和Position字段的值slave中将会用到，在slave操作完成之前不要操作master，否则将会引起状态变化，即File和Position字段的值变化 !!!
# +------------------+----------+-----------------+------------------+-------------------+
# | File             | Position | Binlog_Do_DB    | Binlog_Ignore_DB | Executed_Gtid_Set |
# +------------------+----------+-----------------+------------------+-------------------+
# | mysql-bin.000003 |      725 | acedia-mysql-db |                  |                   |
# +------------------+----------+-----------------+------------------+-------------------+
# 1 row in set (0.00 sec)


# ================== ↓↓↓↓↓↓ 配置从库 ↓↓↓↓↓↓ ==================
# 1.进入从库
docker exec -it acedia-mysql-db-slave-backup /bin/bash
# 2.登录mysql
mysql -uroot -p
# 3.选中主库
CHANGE MASTER TO master_host='172.23.10.2',
                 master_port=3306,
                 master_user='acedia-slave',
                 master_password='acedia-slave@123',
                 master_log_file='mysql-bin.000003',
                 master_log_pos= 725,
                 master_connect_retry=30;
### master_host：Master 的地址，指的是容器的独立 ip, 可以通过 docker inspect --format='{{.NetworkSettings.IPAddress}}' 容器名称 | 容器 id 查询容器的 ip
### master_port：Master 的端口号，指的是容器的端口号
### master_user：用于数据同步的用户
### master_password：用于同步的用户的密码
### master_log_file：指定 Slave 从哪个日志文件开始复制数据，即上文中提到的 File 字段的值
### master_log_pos：从哪个 Position 开始读，即上文中提到的 Position 字段的值
### master_connect_retry：如果连接失败，重试的时间间隔，单位是秒，默认是 30 秒

# 4.在 Slave 中的 mysql 终端执行 show slave status \G; 用于查看主从同步状态。
show slave status \G;
# 正常情况下，SlaveIORunning 和 SlaveSQLRunning 都是 No，因为我们还没有开启主从复制过程。
# *************************** 1. row ***************************
#                Slave_IO_State:
#                   Master_Host: 172.23.10.2
#                   Master_User: acedia-slave
#                   Master_Port: 3306
#                 Connect_Retry: 30
#               Master_Log_File: mysql-bin.000003
#           Read_Master_Log_Pos: 157
#                Relay_Log_File: eb3dc726f093-relay-bin.000001
#                 Relay_Log_Pos: 4
#         Relay_Master_Log_File: mysql-bin.000003
#              Slave_IO_Running: No
#             Slave_SQL_Running: No
#               Replicate_Do_DB:
#           Replicate_Ignore_DB:
#            Replicate_Do_Table:
#        Replicate_Ignore_Table:
#       Replicate_Wild_Do_Table:
#   Replicate_Wild_Ignore_Table:
#                    Last_Errno: 0
#                    Last_Error:
#                  Skip_Counter: 0

# 5.开启主从同步过程  【停止命令：stop slave;】
start slave;
# 6.再次查看主从同步状态
show slave status \G;
# Slave_IO_Running 和 Slave_SQL_Running 都是Yes的话，就说明主从同步已经配置好了！
# 如果Slave_IO_Running为Connecting，SlaveSQLRunning为Yes，则说明配置有问题，这时候就要检查配置中哪一步出现问题了哦，可根据Last_IO_Error字段信息排错或谷歌…
# *************************** 1. row ***************************
#                Slave_IO_State: Waiting for master to send event
#                   Master_Host: www.zhengqingya.com
#                   Master_User: slave
#                   Master_Port: 3306
#                 Connect_Retry: 30
#               Master_Log_File: mysql-bin.000003
#           Read_Master_Log_Pos: 769
#                Relay_Log_File: c598d8402b43-relay-bin.000002
#                 Relay_Log_Pos: 320
#         Relay_Master_Log_File: mysql-bin.000003
#              Slave_IO_Running: Yes
#             Slave_SQL_Running: Yes
#               Replicate_Do_DB:

# 主从复制排错：
# 使用 start slave 开启主从复制过程后，如果 SlaveIORunning 一直是 Connecting，则说明主从复制一直处于连接状态，这种情况一般是下面几种原因造成的，我们可以根据 Last_IO_Error 提示予以排除。
# * 网络不通: 检查 ip, 端口
# * 密码不对: 检查是否创建用于同步的用户和用户密码是否正确
# * pos 不对: 检查 Master 的 Position
# *************************** 1. row ***************************
#                Slave_IO_State: Connecting to source
#                   Master_Host: 172.23.10.2
#                   Master_User: acedia-slave
#                   Master_Port: 3306
#                Master_Log_File: mysql-bin.000003
#           Read_Master_Log_Pos: 157
#                Relay_Log_File: eb3dc726f093-relay-bin.000001
#                 Relay_Log_Pos: 4
#         Relay_Master_Log_File: mysql-bin.000003
#              Slave_IO_Running: Connecting
#             Slave_SQL_Running: Yes
#               Replicate_Do_DB:
#           Replicate_Ignore_DB:
#            Replicate_Do_Table:
#        Replicate_Ignore_Table:
#       Replicate_Wild_Do_Table:
#   Replicate_Wild_Ignore_Table:
#                    Last_Errno: 0
#                    Last_Error:
#                  Skip_Counter: 0
#           Exec_Master_Log_Pos: 157
#               Relay_Log_Space: 157
#               Until_Condition: None
#                Until_Log_File:
#                 Until_Log_Pos: 0
#            Master_SSL_Allowed: No
#            Master_SSL_CA_File:
#            Master_SSL_CA_Path:
#               Master_SSL_Cert:
#             Master_SSL_Cipher:
#                Master_SSL_Key:
#         Seconds_Behind_Master: NULL
# Master_SSL_Verify_Server_Cert: No
#                 Last_IO_Errno: 1045
#                 Last_IO_Error: Error connecting to source 'acedia-slave@172.23.10.2:3306'. This was attempt 1/10, with a delay of 30 seconds between attempts. Message: Access denied for user 'acedia-slave'@'172.23.10.2' (using password: YES)
```

###### 解决主从同步数据不一致问题

```shell
# 注意：操作的时候停止主库数据写入

# 在从库查看主从同步状态
docker exec -it mysql_slave /bin/bash
mysql -uroot -proot
show slave status \G
#              Slave_IO_Running: Yes
#             Slave_SQL_Running: No

# 1、手动同步主从库数据
# 先在从库停止主从同步
stop slave;
# 导出主库数据
mysqldump -h www.zhengqingya.com -P 3306 -uroot -proot --all-databases > /tmp/all.sql
# 导入到从库
mysql -uroot -proot
source /tmp/all.sql;

# 2、开启主从同步
# 查看主库状态 => 拿到File和Position字段的值
docker exec -it mysql_master /bin/bash
mysql -uroot -proot
show master status;
# 从库操作
change master to master_host='www.zhengqingya.com',master_port=3306, master_user='slave', master_password='123456', master_log_file='mysql-bin.000004', master_log_pos= 488117, master_connect_retry=30;
start slave;
# 查看主从同步状态
show slave status \G
#              Slave_IO_Running: Yes
#             Slave_SQL_Running: Yes
```
