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

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

WORKDIR /home

COPY replication-setup.sh /home/

# 设置容器启动时执行的命令
CMD ["mysqld"]
