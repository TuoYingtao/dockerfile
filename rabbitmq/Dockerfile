# 构建时指定的参数变量
ARG RABBITMQ_VERSION="3.13-rc-management"

# 基础镜像
FROM rabbitmq:${RABBITMQ_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao

LABEL maintainer="TuoYingtao" description="RabbitMQ 服务" version="${RABBITMQ_VERSION}"

# 设置时区为上海
ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone
