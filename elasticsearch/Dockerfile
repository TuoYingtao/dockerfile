# 构建时指定的参数变量
ARG ES_VERSION="7.4.2"

# 基础镜像
FROM docker.elastic.co/elasticsearch/elasticsearch:${ES_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="ES 服务" version="${NACOS_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai" \
    ES_JAVA_OPTS="-Xms2048m -Xmx2048m"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone