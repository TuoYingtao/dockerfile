# Docker 构建与运行指南（多平台支持）

本指南用于构建和运行支持多平台（特别是 `linux/amd64`）的 Docker 镜像。

---

## 🧠 1. 查看当前 CPU 架构

### 查看本机 CPU 架构
```bash
uname -m
```

* x86_64 表示 linux/amd64 架构

* aarch64 表示 linux/arm64 架构

### 查看镜像支持的架构
```shell
docker inspect <镜像名>:<tag> | grep Architecture
```

## 🏗️ 2. 构建 Docker 镜像

### ✅ 构建目标平台为 linux/amd64

> 适用于服务器使用 x86_64 架构时

```shell
docker build --platform linux/amd64 -t <镜像名>:<tag> .
```

## ☁️ 3. 构建并上传到 Docker Hub（远程推送）

### 📦 构建带 Python 环境 + zsign 的镜像

```shell
docker build --platform linux/amd64 \
  -t tuoyingtao/usign-python:3_ubuntu_amd64 \
  -f Dockerfile-zsign .
```

### 📤 推送到 Docker Hub

```shell
docker push tuoyingtao/usign-python:3_ubuntu_amd64
```

## 💻 4. 构建本地开发调试镜像

```shell
docker build -t ipa-zsign -f Dockerfile-zsign .
```

### 运行容器并挂载当前目录

```shell
docker run --rm -it \
  -v $(pwd):/app \
  ipa-zsign /bin/bash
```

## ⚙️ 5. 启动命令说明（示例）

```shell
docker run --rm -it \
  -e REDIS_HOST=redis \
  -v $(pwd)/ipa:/opt/app/ipa \
  tuoyingtao/usign-python:3_ubuntu_amd64 \
  /opt/app/venv/bin/python main.py
```
