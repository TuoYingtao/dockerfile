#!/bin/sh
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 执行过程中如果发生错误，立即退出
set -e

PROJECT_NAME=""

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy.sh [options]"
	echo "用于Copy Docker环境部署所需要的文件"
	echo ""
	echo "options:"
	echo "* -h | --help                      帮助信息"
	echo "* -j | --jar                       copy jar"
	echo "* -s | --sql                       copy sql"
	echo "* -c | --copy                      copy all"
	exit 1
}

# copy sql
copySql() {
  echo "begin copy sql... "
  cp ../db/privileges.sql ./mysql/db
  cp ../db/whale-tik-cloud.sql ./mysql/db
  echo "finish copy sql. "
}

# copy jar
copyJar() {
    echo "begin copy $PROJECT_NAME "
    cp ../${PROJECT_NAME}/target/${PROJECT_NAME}.jar ./jar
    echo "finish copy $PROJECT_NAME. "
}

copyAll() {
  copySql
  copyJar
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            usage
            shift
            ;;
        -j|--jar)
            copyJar
            shift
            ;;
        -s|--sql)
            copySql
            shift
            ;;
        -c|--copy)
            copyAll
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
