# 构建时指定的参数变量
ARG NACOS_VERSION=latest

# 基础镜像
FROM nacos/nacos-server:${NACOS_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="Nacos 服务" version="${NACOS_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai" \
    NACOS_APPLICATION_PORT=9999 \
    JVM_XMS=512m \
    JVM_MMS=320m

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone
