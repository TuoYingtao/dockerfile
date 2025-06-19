#!/bin/bash

set -e

IMAGE_NAME="tuoyingtao/usign-python"
TAG="3_ubuntu_amd64"
PLATFORM="linux/amd64"
DOCKERFILE="Dockerfile-service-app-client-bash"

usage() {
  echo "用法: $0 {build|run|push|shell}"
  exit 1
}

build() {
  echo "👉 构建镜像: $IMAGE_NAME:$TAG"
  docker build --platform $PLATFORM -t $IMAGE_NAME:$TAG -f $DOCKERFILE .
}

run() {
  echo "🚀 运行镜像: $IMAGE_NAME:$TAG"
  docker run --rm -it -v "$(pwd):/app" $IMAGE_NAME:$TAG /bin/bash
}

push() {
  echo "📤 推送镜像到 Docker Hub: $IMAGE_NAME:$TAG"
  docker push $IMAGE_NAME:$TAG
}

shell() {
  echo "🔧 启动交互 Shell: $IMAGE_NAME:$TAG"
  docker run --rm -it -v "$(pwd):/app" $IMAGE_NAME:$TAG /bin/bash
}

case "$1" in
  build) build ;;
  run) run ;;
  push) push ;;
  shell) shell ;;
  *) usage ;;
esac
