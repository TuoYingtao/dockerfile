# 构建时指定的参数变量
ARG MYSQL_VERSION=8.2.0

# 基础镜像
FROM mysql:${MYSQL_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="mysql 服务" version="${MYSQL_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai" \
# 设置免密登录
    MYSQL_ALLOW_EMPTY_PASSWORD=no


# 执行sql脚本
ADD /db/*.sql /docker-entrypoint-initdb.d/

# 将所需文件放到容器中
COPY "./setup.sh" "./setup.sh"
COPY /db/*.sql /mysql/

# 阉割版SQL是没有将mysqlbinlog构建进去需要这就导入
#COPY /tools/mysqlbinlog-5.7.10 /usr/bin/mysqlbinlog
COPY /tools/mysqlbinlog-8.0.32-debian /usr/bin/mysqlbinlog


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# 设置容器启动时执行的命令
CMD ["sh", "./setup.sh"]
