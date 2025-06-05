# Supervisor 安装配置

## 基础环境
```text
ubuntu: 22.04
python: 3.10.6 and 3.8.20
```

## 检查宿主机是否存在Python环境

```shell
# -------------------------------
# 更新包列表并安装常用工具
# -------------------------------
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
# 方式一：全局系统配置Python环境

# -------------------------------
# 安装前设置别名和 Python 路径（可选）
# -------------------------------
echo 'export PATH="/usr/bin/python3.8:$PATH"' >> ~/.bashrc
echo 'alias python=python3.8' >> ~/.bashrc
source ~/.bashrc

# -------------------------------
# 使用 Python3.8 的 pip 安装 virtualenv 和 virtualenvwrapper（全局安装）
# -------------------------------
sudo /usr/bin/python3.8 -m pip install virtualenv virtualenvwrapper

# -------------------------------
# 设置 PATH 变量以包含用户 bin 和 site-packages
# -------------------------------
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH=/usr/local/lib/python3.8/dist-packages/:$PATH' >> ~/.bashrc

# -------------------------------
# 添加 virtualenvwrapper 配置
# -------------------------------
echo 'export WORKON_HOME=~/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.8' >> ~/.bashrc

# -------------------------------
# 如果加载不到文件可以先查询具体路径：sudo find / -name "virtualenvwrapper.sh" 2>/dev/null | head -n 1
# 或者 echo 'source $HOME/.local/bin/virtualenvwrapper.sh' >> ~/.bashrc
# -------------------------------
source $(which virtualenvwrapper.sh)
echo 'source 文件路径virtualenvwrapper.sh' >> ~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc

source ~/.bashrc

# -------------------------------
# 创建和进入虚拟环境
# -------------------------------
mkvirtualenv myenv

# -------------------------------
# 进入虚拟环境
# -------------------------------
workon myenv

# -------------------------------
# 安装 pip 到虚拟环境（这步通常不需要，如果已有 pip 可省略）
# -------------------------------
wget https://bootstrap.pypa.io/get-pip.py -P ~/.virtualenvs/myenv/bin/
python ~/.virtualenvs/myenv/bin/get-pip.py 

# -------------------------------
# 使用指令管理虚拟环境
# -------------------------------
lsvirtualenv        # 查看所有虚拟环境
rmvirtualenv myenv  # 删除虚拟环境
deactivate          # 退出虚拟环境
workon myenv        # 再次激活
```

```shell
# 方式二：用户级配置Python环境

# -------------------------------
# 设置 Python3.8 环境（可选）
# -------------------------------
echo 'export PATH="/usr/bin/python3.8:$PATH"' >> ~/.bashrc
echo 'alias python=python3.8' >> ~/.bashrc
source ~/.bashrc

# -------------------------------
# 安装 virtualenv 和 virtualenvwrapper（用户级）
# -------------------------------
/usr/bin/python3.8 -m pip install --user virtualenv virtualenvwrapper

# -------------------------------
# 设置 PATH 变量以包含用户 bin 和 site-packages
# -------------------------------
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PYTHONPATH="$HOME/.local/lib/python3.8/site-packages:$PYTHONPATH"' >> ~/.bashrc

# -------------------------------
# 添加 virtualenvwrapper 配置
# -------------------------------
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.8' >> ~/.bashrc

# -------------------------------
# 自动查找 virtualenvwrapper.sh 并配置 source
# -------------------------------
VENVWRAPPER_PATH=$(find $HOME/.local -name virtualenvwrapper.sh 2>/dev/null | head -n 1)
if ! grep -q 'virtualenvwrapper.sh' ~/.bashrc && [ -n "$VENVWRAPPER_PATH" ]; then
  echo "source $VENVWRAPPER_PATH" >> ~/.bashrc
fi

# -------------------------------
# 应用 bashrc 配置
# -------------------------------
source ~/.bashrc
```


## 安装Supervisor

```shell
# -------------------------------
# 1. 安装 Supervisor
# -------------------------------
sudo apt-get update && sudo apt-get install -y supervisor

# -------------------------------
# 2. 清理 APT 缓存（可选）
# -------------------------------
sudo apt-get clean 
sudo rm -rf /var/lib/apt/lists/*

# -------------------------------
# 3. 创建 supervisor 的 socket 和 program 配置目录
# -------------------------------
sudo mkdir -p /tmp/supervisor
sudo mkdir -p /etc/supervisordfile

# -------------------------------
# 4. 备份原始配置（如果存在）
# -------------------------------
[ -f /etc/supervisor/supervisord.conf ] && \
  sudo cp -vfp /etc/supervisor/supervisord.conf /etc/supervisor/supervisord_old.conf

# -------------------------------
# 5. 写入主配置文件 supervisord.conf
# -------------------------------
sudo tee /etc/supervisor/supervisord.conf > /dev/null <<EOF
[unix_http_server]
file=/tmp/supervisor/supervisor.sock

[inet_http_server]
port=*:9001
username=admin
password=adminpass

[supervisord]
logfile=/tmp/supervisor/supervisord.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info
pidfile=/tmp/supervisor/supervisord.pid
nodaemon=false
minfds=1024
minprocs=200

[supervisorctl]
serverurl=unix:///tmp/supervisor/supervisor.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory=supervisor.rpcinterface:make_main_rpcinterface

[include]
files=/etc/supervisor/conf.d/*.ini
EOF

# -------------------------------
# 6. 检查 supervisord 和 supervisorctl 路径
# -------------------------------
which supervisord
which supervisorctl

# -------------------------------
# 7. 创建 systemd 服务文件（如使用自定义配置）
# 通常 Ubuntu 安装完 Supervisor 后，会自动创建以下文件: /lib/systemd/system/supervisor.service
# 自定义systemd 服务文件创建: sudo nano /etc/systemd/system/supervisor.service
# 查询日志： journalctl -u supervisor-cph.service -b
# -------------------------------
sudo tee /etc/systemd/system/supervisor-cph.service > /dev/null <<EOF
[Unit]
Description=Supervisor daemon
Documentation=http://supervisord.org
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
ExecStop=/usr/bin/supervisorctl $OPTIONS shutdown
ExecReload=/usr/bin/supervisorctl -c /etc/supervisor/supervisord.conf $OPTIONS reload
KillMode=process
Restart=on-failure
RestartSec=50s

[Install]
WantedBy=multi-user.target
EOF

# -------------------------------
# 8. 启用并启动服务
# -------------------------------
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable supervisord
sudo systemctl restart supervisord
sudo systemctl status supervisord
```

📦 Supervisor 程序管理使用
```shell
# -------------------------------
# 创建一个示例程序配置（如 Node/Python 守护进程）
# 替换 /path/to/your/app.py 为你的实际程序路径
# -------------------------------
sudo tee /etc/supervisordfile/myapp.ini > /dev/null <<EOF
[program:myapp]
command=/usr/bin/python3 /path/to/your/app.py
directory=/path/to/your
autostart=true
autorestart=true
stderr_logfile=/tmp/supervisor/myapp.err.log
stdout_logfile=/tmp/supervisor/myapp.out.log
EOF

sudo tee /etc/supervisor/conf.d/hello.ini > /dev/null <<EOF
[program:hello]
command=/bin/bash -c "while true; do echo hello; sleep 60; done"
autostart=false
startsecs=10
autorestart=true
startretries=5
user=root
priority=999
redirect_stderr=true
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=20
stderr_logfile=/home/projects/logs/hello.err.log
stdout_logfile=/home/projects/logs/hello.out.log
stopasgroup=true
killasgroup=true
EOF
```


如果你使用的是 custom.conf 路径或非默认的 systemd 服务名（比如 supervisor 而非 supervisord），你可以用下面快速查找当前实际服务名：
```shell
systemctl list-units --type=service | grep supervisor
```

| 功能                    | 命令                                                               |
| --------------------- | ---------------------------------------------------------------- |
| 启动 `supervisord` 服务   | `sudo systemctl start supervisord`                               |
| 停止 `supervisord` 服务   | `sudo systemctl stop supervisord`                                |
| 重启 `supervisord` 服务   | `sudo systemctl restart supervisord`                             |
| 查看 `supervisord` 状态   | `sudo systemctl status supervisord`                              |
| 设置 `supervisord` 开机启动 | `sudo systemctl enable supervisord`                              |
| 取消开机启动                | `sudo systemctl disable supervisord`                             |
| 重新加载 systemd 配置       | `sudo systemctl daemon-reload`                                   |
| 强制刷新服务状态（避免缓存）        | `sudo systemctl daemon-reexec`                                   |
| 查看服务日志（journal）       | `journalctl -u supervisord -f`（实时） 或 `journalctl -u supervisord` |
| 停止所有 Supervisor 子程序   | `supervisorctl shutdown`                                         |

| 功能                 | 命令                                          |
| ------------------ | ------------------------------------------- |
| 启动某个程序             | `supervisorctl start <program>`             |
| 停止某个程序             | `supervisorctl stop <program>`              |
| 重启某个程序             | `supervisorctl restart <program>`           |
| 查看程序状态             | `supervisorctl status`                      |
| 重载配置文件（不重启程序）      | `supervisorctl reread`                      |
| 更新配置并启动新配置程序       | `supervisorctl update`                      |
| 重启所有程序（包括配置）       | `supervisorctl reload`（⚠️ 会 kill 掉所有程序）     |
| 实时查看某个程序日志（stdout） | `tail -f /tmp/supervisor/<program>.out.log` |
| 实时查看某个程序日志（stderr） | `tail -f /tmp/supervisor/<program>.err.log` |


# Supervisor 程序配置示例模板（/etc/supervisordfile/myapp.ini）

```shell
[program:myapp]
command=/usr/bin/python3 /path/to/your/app.py         ; 启动命令（根据实际调整）
autostart=true                                         ; 开机自动启动
autorestart=true                                       ; 程序退出后自动重启
startretries=3                                        ; 启动失败重试次数
user=ubuntu                                           ; 以哪个用户运行（避免用 root）
stdout_logfile=/tmp/supervisor/myapp.out.log          ; 标准输出日志路径
stderr_logfile=/tmp/supervisor/myapp.err.log          ; 错误日志路径
stdout_logfile_maxbytes=10MB                           ; 日志最大大小，超出自动轮转
stderr_logfile_maxbytes=10MB
stdout_logfile_backups=5                               ; 轮转日志保留份数
stderr_logfile_backups=5
environment=ENVIRONMENT="production",DEBUG="false"    ; 传递环境变量（可选）
```

```shell
[inet_http_server]
port=*:9001
username=admin
password=adminpass
```

```shell
# 限制访问IP 不建议直接开放 0.0.0.0:9001，可以限定为内网IP或本地回环地址：
[inet_http_server]
port=127.0.0.1:9001
username=admin
password=adminpass
```
