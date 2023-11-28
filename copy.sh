#!/bin/sh

PROJECT_NAME=""

# 复制项目的文件到对应docker路径，便于一键生成镜像。
usage() {
	echo "Usage: sh copy.sh"
	exit 1
}


# copy sql
echo "begin copy sql "
cp ../db/privileges.sql ./mysql/db

# copy jar
echo "begin copy $PROJECT_NAME "
cp ../${PROJECT_NAME}/target/${PROJECT_NAME}.jar ./jar
