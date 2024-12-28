# 构建时指定的参数变量
ARG REDIS_VERSION=7.2
ARG REDIS_PASSWORD=redis@tuoyingtao.com

# 基础镜像
FROM redis:${REDIS_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao

LABEL maintainer="TuoYingtao" description="Redis 服务" version="${REDIS_VERSION}"

ENV TZ="Asia/Shanghai" \
    APPENDONLY=yes \
    REQUIREPASS=${REDIS_PASSWORD}


COPY /conf/redis.conf /usr/local/etc/redis/redis.conf

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone

CMD ["sh", "-c", "redis-server", "--requirepass", "${REDIS_PASSWORD}", "&&",  "redis-server", "/usr/local/etc/redis/redis.conf"]
