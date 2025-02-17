# 构建时指定的参数变量
ARG CLICKHOUSE_VERSION="latest"

# 基础镜像
FROM clickhouse/clickhouse-server:${CLICKHOUSE_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="Clickhouse 服务" version="${CLICKHOUSE_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone
