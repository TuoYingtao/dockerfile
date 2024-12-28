# 构建时指定的参数变量
ARG UBUNTU_VERSION=22.04

# 基础镜像
FROM ubuntu:${UBUNTU_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="ubuntu 环境" version="${UBUNTU_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone



ENTRYPOINT ["top", "-b"]