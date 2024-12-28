# 构建时指定的参数变量
ARG UBUNTU_VERSION=22.04
ARG PYTHON_VERSION=3.8

# 基础镜像
FROM ubuntu:${UBUNTU_VERSION}

# 镜像维护者
MAINTAINER TuoYingtao
LABEL maintainer="TuoYingtao" description="ubuntu 环境" version="${UBUNTU_VERSION}"

# 设置时区为上海
ENV TZ="Asia/Shanghai"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# supervisor配置文件路径
ENV SUPERVISORD_CONF=/etc/supervisor/supervisord.conf
# supervisor临时文件路径(日志文件、sock文件、pid文件)
ENV SUPERVISORD_TMP_CONF=/tmp/supervisor
# supervisor程序块文件路径,即是[program]块
ENV SUPERVISORD_INCLUDE_FILE=/etc/supervisordfile
# web管理界面的IP
ENV SUPERVISORD_WEB_IP=*
# web管理界面的PORT
ENV SUPERVISORD_WEB_PORT=9001
# web管理界面的账号
ENV SUPERVISORD_WEB_ACCOUNT=admin
# web管理界面的密码
ENV SUPERVISORD_WEB_PASSWORD=adminpass


# 更新包列表并安装常用工具
RUN apt-get update  \
    && apt-get install -y vim curl wget git build-essential \
    && apt-get install -y software-properties-common \
    && apt-get install -y build-essential libssl-dev libffi-dev python3-dev \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python${PYTHON_VERSION} python3-pip \
    && apt-cache policy python${PYTHON_VERSION} \
    && apt-get install -y python${PYTHON_VERSION}-venv python${PYTHON_VERSION}-distutils \
    && apt-get install -y supervisor \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# Python 环境配置
#RUN echo 'export PATH="/usr/bin/python${PYTHON_VERSION}:$PATH"' >> ~/.bashrc \
#    && echo 'alias python=python${PYTHON_VERSION}' >> ~/.bashrc \
#    && source ~/.bashrc \
#    && pip install virtualenv \
#    && pip install virtualenvwrapper \
#    && echo 'export PATH=/usr/local/lib/python${PYTHON_VERSION}/dist-packages/:$PATH' >> ~/.bashrc \
#    && echo 'export WORKON_HOME=~/.virtualenvs' >> ~/.bashrc \
#    && echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python${PYTHON_VERSION}' >> ~/.bashrc \
#    && source ~/.bashrc \
#    && source $(which virtualenvwrapper.sh) \
#    && mkvirtualenv myenv \
#    && workon myenv \
#    && wget https://bootstrap.pypa.io/get-pip.py -P ~/.virtualenvs/myenv/bin/ \
#    && python ~/.virtualenvs/myenv/bin/get-pip.py  \
#    && deactivate

# Supervisor 环境配置
#RUN mkdir -p ${SUPERVISORD_TMP_CONF} && mkdir -p ${SUPERVISORD_INCLUDE_FILE} \
#    && cp -vfp ${SUPERVISORD_CONF} /etc/supervisor/supervisord_old2.conf \
#    && echo -e "[unix_http_server]\nfile=${SUPERVISORD_TMP_CONF}/supervisor.sock\n[inet_http_server]\nport=${SUPERVISORD_WEB_IP}:${SUPERVISORD_WEB_PORT}\nusername=${SUPERVISORD_WEB_ACCOUNT}\npassword=${SUPERVISORD_WEB_PASSWORD}\n[supervisord]\nlogfile=${SUPERVISORD_TMP_CONF}/supervisord.log\nlogfile_maxbytes=50MB\nlogfile_backups=10\nloglevel=info\npidfile=${SUPERVISORD_TMP_CONF}/supervisord.pid\nnodaemon=false\nminfds=1024\nminprocs=200\n[supervisorctl]\nserverurl=unix://${SUPERVISORD_TMP_CONF}/supervisor.sock\n[rpcinterface:supervisor]\nsupervisor.rpcinterface_factory=supervisor.rpcinterface:make_main_rpcinterface\n[include]\nfiles=${SUPERVISORD_INCLUDE_FILE}/*.ini" > ${SUPERVISORD_CONF} \
#    && echo 'export PATH="/usr/bin/supervisord:$PATH"' >> ~/.bashrc \
#    && echo 'export PATH="/usr/bin/supervisorctl:$PATH"' >> ~/.bashrc \
#    && source ~/.bashrc \
#    && supervisord -c /etc/supervisor/supervisord.conf \
#    && systemctl status supervisord

#COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf

# 写入supervisor配置文件
#RUN echo -e "[unix_http_server]\nfile=${SUPERVISORD_TMP_CONF}/supervisor.sock\n[inet_http_server]\nport=${SUPERVISORD_WEB_IP}:${SUPERVISORD_WEB_PORT}\nusername=${SUPERVISORD_WEB_ACCOUNT}\npassword=${SUPERVISORD_WEB_PASSWORD}\n[supervisord]\nlogfile=${SUPERVISORD_TMP_CONF}/supervisord.log\nlogfile_maxbytes=50MB\nlogfile_backups=10\nloglevel=info\npidfile=${SUPERVISORD_TMP_CONF}/supervisord.pid\nnodaemon=false\nminfds=1024\nminprocs=200\n[supervisorctl]\nserverurl=unix://${SUPERVISORD_TMP_CONF}/supervisor.sock\n[include]\nfiles = ${SUPERVISORD_INCLUDE_FILE}/*.ini" > ${SUPERVISORD_CONF}

EXPOSE 22 80 9001

# 设置工作目录
WORKDIR /app

# 启动一个交互式 shell
CMD ["/bin/bash"]