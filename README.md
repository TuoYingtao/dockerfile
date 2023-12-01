# dockerfile
Dockerfile 镜像构建

## Note 

1. Docker 初始化SQL异常：`Error: , SQL State: 00000, Message: Transaction failed`。

    `mysql -> db` 文件夹下的 `[privileges.sql](mysql%2Fdb%2Fprivileges.sql)` 在部署到Docker容器中进行初始化时，会提示以下报错信息:
    ```shell
    ErrResult
    Error: , SQL State: 00000, Message: Transaction failed
    ```
    这是因为在`[privileges.sql](mysql%2Fdb%2Fprivileges.sql)`的InitDatabaseAndUser存储过程中捕获到的异常。
    而报错的原因是由这段代码引起的：
    ```sql
    -- 数据库名称
    SET @DATABASE_NAME = '${MYSQL_DATABASE}';
    -- 数据库角色
    SET @DATABASE_USER_NAME = '${MYSQL_USER}';
    SET @DATABASE_USER_PASS = '${MYSQL_PASSWORD}';
    ```
    在SQL这种写法就是普通的字符串，而在Docker容器中会将相应的环境变量做替换，不要过于在意它，但有一点值得注意，一定要确保你的`.sql`全部执行完毕最终出现一下信息：
    ```shell
    [Note] [Entrypoint]: /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initdb.d/[Your sql file name].sql
    [Note] [Entrypoint]: MySQL init process done. Ready for start up.
    ```
