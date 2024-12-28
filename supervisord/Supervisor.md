# Supervisor 安装配置

## 基础环境
```text
ubuntu: 22.04
python: 3.10.6 and 3.8.20
```

## 检查宿主机是否存在Python环境

```shell
# 更新包列表并安装常用工具
apt-get update
apt-get install -y software-properties-common
apt-get install -y build-essential libssl-dev libffi-dev python3-dev
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update
apt-get install -y wget python3.8 python3-pip
apt-cache policy python3.8
apt-get install -y python3.8-venv python3.8-distutils
apt-get autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*
```

```shell
# 配置环境
echo 'export PATH="/usr/bin/python3.8:$PATH"' >> ~/.bashrc
echo 'alias python=python3.8' >> ~/.bashrc
source ~/.bashrc
pip install virtualenv
pip install virtualenvwrapper
echo 'export PATH=/usr/local/lib/python3.8/dist-packages/:$PATH' >> ~/.bashrc
echo 'export WORKON_HOME=~/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.8' >> ~/.bashrc
source ~/.bashrc
source $(which virtualenvwrapper.sh)
mkvirtualenv myenv
workon myenv
wget https://bootstrap.pypa.io/get-pip.py -P ~/.virtualenvs/myenv/bin/
python ~/.virtualenvs/myenv/bin/get-pip.py 
deactivate
```

## 安装Supervisor

```shell
apt-get update && apt-get install -y supervisor
apt-get clean 
rm -rf /var/lib/apt/lists/*
mkdir -p /tmp/supervisor && mkdir -p /etc/supervisordfile
cp -vfp /etc/supervisor/supervisord.conf /etc/supervisor/supervisord_old2.conf
echo -e "[unix_http_server]\nfile=/tmp/supervisor/supervisor.sock\n[inet_http_server]\nport=*:9001\nusername=admin\npassword=adminpass\n[supervisord]\nlogfile=/tmp/supervisor/supervisord.log\nlogfile_maxbytes=50MB\nlogfile_backups=10\nloglevel=info\npidfile=/tmp/supervisor/supervisord.pid\nnodaemon=false\nminfds=1024\nminprocs=200\n[supervisorctl]\nserverurl=unix:///tmp/supervisor/supervisor.sock\n[rpcinterface:supervisor]\nsupervisor.rpcinterface_factory=supervisor.rpcinterface:make_main_rpcinterface\n[include]\nfiles=/etc/supervisordfile/*.ini" > /etc/supervisor/supervisord.conf
echo 'export PATH="/usr/bin/supervisord:$PATH"' >> ~/.bashrc
echo 'export PATH="/usr/bin/supervisorctl:$PATH"' >> ~/.bashrc
source ~/.bashrc
supervisord -c /etc/supervisor/supervisord.conf 
systemctl status supervisord
```

