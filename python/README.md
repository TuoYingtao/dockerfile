# Python 安装配置

## 基础环境
```text
ubuntu: 22.04
```

## 安装Python
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
python3.8 -m venv myenv
source myenv/bin/activate
wget https://bootstrap.pypa.io/get-pip.py -P myenv/bin
python3.8 myenv/bin/get-pip.py
```

```shell
# 配置环境变量
# 对于 bash 用户
echo 'export PATH="/path/to/your/python3.8/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 对于 zsh 用户
echo 'export PATH="/path/to/your/python3.8/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 在 ~/.bashrc 或 ~/.zshrc 中添加以下行
echo 'alias python=python3.8' >> ~/.bashrc
echo 'alias pip=pip3.8' >> ~/.bashrc

# 对于 zsh 用户
echo 'alias python=python3.8' >> ~/.zshrc
echo 'alias pip=pip3.8' >> ~/.zshrc

# 对于 bash 用户
source ~/.bashrc

# 对于 zsh 用户
source ~/.zshrc

python --version
pip --version
```

```shell
# 虚拟环境管理工具
# 第一种virtualenv
# 首先安装 virtualenv
pip install virtualenv

# 然后安装 virtualenvwrapper
pip install virtualenvwrapper

# 设置虚拟环境安装位置（查看：pip show virtualenvwrapper | grep Location）
echo 'export PATH=/usr/local/lib/python3.8/dist-packages/:$PATH' >> ~/.bashrc
source ~/.bashrc

# 设置虚拟环境存放位置（可以自定义）
echo 'export WORKON_HOME=~/.virtualenvs' >> ~/.bashrc
source ~/.bashrc

# 指定python解释器
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.8' >> ~/.bashrc
source ~/.bashrc

# 加载 virtualenvwrapper
source $(which virtualenvwrapper.sh)

source ~/.bashrc  # 或 source ~/.zshrc

# 创建虚拟环境
mkvirtualenv myenv
# 激活虚拟环境
workon myenv
# 停用虚拟环境
deactivate
# 列出所有虚拟环境
lsvirtualenv
# 删除虚拟环境
rmvirtualenv myenv

# 第二种pyenv 和 pyenv-virtualenv
# 安装 pyenv
curl https://pyenv.run | bash

# 然后安装 pyenv-virtualenv 插件
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# 配置 pyenv 在 ~/.bashrc 或 ~/.zshrc 中添加以下行
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.bashrc  # 或 source ~/.zshrc
# 安装指定 Python 版本
pyenv install 3.8.5
# 创建虚拟环境
pyenv virtualenv 3.8.5 myenv
# 激活虚拟环境
pyenv activate myenv
# 停用虚拟环境
pyenv deactivate
# 列出所有虚拟环境
pyenv virtualenvs
# 删除虚拟环境
pyenv uninstall myenv
```