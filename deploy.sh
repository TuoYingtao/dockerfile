#!/bin/sh
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#===================================== Shell 环境配置 =========================================

PROJECT_NAME=""

# 基础环境变量
BASE_ENVS=(
  ${PROJECT_NAME}-mysql
)

# 程序服务变量
JAR_PROJECTS=(
  ${PROJECT_NAME}-server
  ${PROJECT_NAME}-server2
)

# 暴露端口变量
EXPORT_PORTS=(
  80
  3307
  8082
)

#========================================= docker =========================================

# 启动所有编排容器服务 或 指定编排容器服务
up() {
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose up -d $1
  else
    docker-compose up -d
  fi
}

# 启动基础环境（必须）
base() {
  for port in ${BASE_ENVS[@]}; do
    docker-compose up -d $port
  done
}

# 启动程序模块（必须）
server() {
  for port in ${JAR_PROJECTS[@]}; do
    docker-compose up -d $port
  done
}

# 进入指定容器执行命令
execs() {
	docker-compose exec $1 bash
}

# 关闭所有环境/模块 或 指定环境/模块
stop() {
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose stop $1
  else
    docker-compose stop
  fi
}

# 删除所有环境/模块 或 指定环境/模块
rm() {
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose rm $1
  else
    docker-compose rm
  fi
}

# 查看正在运行中的容器 或 所有编排容器，包括已停止的容器
ps() {
  if [ "$1" != "--" ] && [ "$1" != "" ] && [ "$1" == "all" ]; then
    docker-compose ps -a
  else
    docker-compose ps
  fi
}

# 查看各个服务容器内运行的进程
top() {
  docker-compose top
}

# 查看mysql容器的实时日志
logs() {
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
    docker-compose logs -f $1
  fi
}

# 默认使用docker-compose.yml构建镜像
build() {
  # --no-cache 不带缓存的构建
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
    # 指定不同yml文件模板用于构建镜像
    docker-compose build -f docker-compose1.yml --no-cache
  else
	  docker-compose build --no-cache
  fi
}

# 停止所有up命令启动的容器,并移除数据卷
down() {
	docker-compose down -v
}

# 重新启动停止服务的容器
restart() {
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose restart $1
  fi
}

# 暂停容器
pause() {
	if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose pause $1
  fi
}

# 恢复容器
unpause() {
	if [ "$1" != "--" ] && [ "$1" != "" ]; then
	  docker-compose unpause $1
  fi
}

#========================================= Linux =========================================

# 开启所需端口
port() {
  for port in ${EXPORT_PORTS[@]}; do
  firewall-cmd --add-port=$port/tcp --permanent
  done
	service firewalld restart
}

#========================================= Shell =========================================

# 添加一个标志来表示是否有解析参数（减去文件名参数）
has_parsed_options=`expr $#`

# 提示信息
starts() {
  echo ""
  echo "${BASH_SOURCE} EnvConfig...."
  echo ""
  echo "基础环境变量(${#BASE_ENVS[@]}): ${BASE_ENVS[@]}"
  echo "程序服务变量(${#JAR_PROJECTS[@]}): ${JAR_PROJECTS[@]}"
  echo "暴露端口(${#EXPORT_PORTS[@]}): ${EXPORT_PORTS[@]}"
  echo ""
  printf "The ${BASH_SOURCE} command is executed.... \n"
  echo ""
}

# 使用说明，用来提示输入参数
usage() {
	echo "Usage: sh 执行脚本.sh [port|up|base|server|stop|rm|ps|top|logs|build]"
}

# 参数计算（减）
options_computer() {
  echo $1
  if [ "$1" != "--" ] && [ "$1" != "" ]; then
    shift 2
    has_parsed_options=`expr $has_parsed_options - 2`
  else
    shift 1
    has_parsed_options=`expr $has_parsed_options - 1`
  fi
}

#========================================= Shell 业务 =========================================

<< COMMENT
定义短选项:
--每一个字符都表示一个短选项
定义长选项
--每一个逗号分割的字符串表示一个长选项
如果一个字符后面跟着一个冒号（:）则表示这个选项需要一个参数。
如果两个冒号（::）表示这个选项的参数是可选的。
COMMENT
short_options="hpu::bse:f:"
long_options="help,port,up::,base,server,execs:,stop::,rm::,ps::,top,logs:,build::,down,restart:,pause:,unpause:"

# 使用 getopt 解析命令行参数
parsed_options=$(getopt -o $short_options -l $long_options -- "$@")

# 检查 getopt 的返回状态
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

# 将解析后的选项赋值给变量
eval set -- "$parsed_options"

# 开始脚本
starts

# 根据输入参数，选择执行对应方法，不输入则执行使用说明
while true; do
  case "$1" in
    -f)
      echo $2
      shift 2
      options_computer $2
    ;;
    -h | --help)
      usage
      exit 0
    ;;
    -p | --port)
      port
      options_computer $2
    ;;
    -u | --up)
      up $2
      options_computer $2
    ;;
    -b | --base)
      base
      options_computer $2
    ;;
    -s | --server)
      server
      options_computer $2
    ;;
    -e | --execs)
      execs $2
      options_computer $2
    ;;
    "--stop")
      stop $2
      options_computer $2
    ;;
    "--rm")
      rm $2
      options_computer $2
    ;;
    "--ps")
      ps $2
      options_computer $2
    ;;
    "--top")
      top
      options_computer $2
    ;;
    "--logs")
      logs $2
      options_computer $2
    ;;
    "--build")
      build $2
      options_computer $2
    ;;
    "--down")
      down
      options_computer $2
    ;;
    "--restart")
      restart $2
      options_computer $2
    ;;
    "--pause")
      pause $2
      options_computer $2
    ;;
    "--unpause")
      unpause $2
      options_computer $2
    ;;
    --)
      shift
      break
    ;;
    *)
      usage
      exit 1
    ;;
  esac
  # 检查是否有解析参数，如果没有则跳出循环
  if [ "$has_parsed_options" = 0 ]; then
    break
  fi
done
