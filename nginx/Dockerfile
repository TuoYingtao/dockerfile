# 构建时指定的参数变量
ARG NGINX_VERSION="stable-alpine3.17-slim"

# 基础镜像
FROM nginx:${NGINX_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao

LABEL maintainer="TuoYingtao" description="Nginx 服务" version="${NGINX_VERSION}"

ENV TZ="Asia/Shanghai"

EXPOSE 80

COPY ./html/index.html /etc/nginx/html/
COPY ./html/50x.html /etc/nginx/html/

WORKDIR /etc/nginx/

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone

ENTRYPOINT nginx -g 'daemon off;'
