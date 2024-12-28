# 构建时指定的参数变量
ARG JAR_VERSION=8-jre
ARG JAR_PROJECT_NAME=java

# 基础镜像
FROM openjdk:${JAR_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao

# 挂载目录
VOLUME ["/home/${JAR_PROJECT_NAME}"]

# 创建目录
RUN mkdir -p /home/${JAR_PROJECT_NAME}

# 指定路径
WORKDIR /home/${JAR_PROJECT_NAME}

# 复制jar文件到挂载目录
COPY /jar/${JAR_PROJECT_NAME}.jar /home/${JAR_PROJECT_NAME}/${JAR_PROJECT_NAME}.jar

# 设置时区为上海
ENV TZ="Asia/Shanghai"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone

ENV JAVA_OPTS="-Xms256m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m"

# 启动系统服务
ENTRYPOINT ["java","-jar", "-Dfile.encoding=utf-8", "${JAVA_OPTS}", "${JAR_PROJECT_NAME}.jar"]
