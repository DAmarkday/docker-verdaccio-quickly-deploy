#!/bin/bash

# 设置脚本失败时退出
set -e

# 定义变量
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERDACCIO_DIR="${SCRIPT_DIR}"
STORAGE_DIR="${VERDACCIO_DIR}/storage"

# 检测操作系统
OS_TYPE=$(uname -s)

# 1. 确认 verdaccio 目录存在且正确
echo "检查 verdaccio 目录..."
# 检查目录是否存在
if [ ! -d "$VERDACCIO_DIR" ]; then
    echo "错误：verdaccio 目录 $VERDACCIO_DIR 不存在"
    exit 1
fi
# 检查目录名是否为 verdaccio
if [ "$(basename "$VERDACCIO_DIR")" != "docker-verdaccio-quickly-deploy" ]; then
    echo "错误：当前目录 $VERDACCIO_DIR 不是 docker-verdaccio-quickly-deploy 目录（目录名必须为 docker-verdaccio-quickly-deploy）"
    exit 1
fi
# 检查关键文件和目录
if [ ! -f "$VERDACCIO_DIR/compose.yaml" ]; then
    echo "错误：$VERDACCIO_DIR 中缺少 compose.yaml 文件"
    exit 1
fi
if [ ! -d "$VERDACCIO_DIR/conf" ]; then
    echo "错误：$VERDACCIO_DIR 中缺少 conf 目录"
    exit 1
fi
#. 检查 Dockerfile
if [ ! -f "$VERDACCIO_DIR/dockerfile" ]; then
    echo "警告：$VERDACCIO_DIR 中缺少 dockerfile "
    exit 1
fi
echo "verdaccio 目录 $VERDACCIO_DIR 验证通过"


# 2. 创建 storage 子目录
echo "创建 storage 子目录..."
if [ ! -d "$STORAGE_DIR" ]; then
    mkdir -p "$STORAGE_DIR"
    echo "已创建 $STORAGE_DIR"
else
    echo "$STORAGE_DIR 已存在"
fi

# 3. 设置 verdaccio 目录权限
echo "设置 $VERDACCIO_DIR 的权限..."
chmod -R 755 "$VERDACCIO_DIR"
if [ "$OS_TYPE" = "Darwin" ]; then
    xattr -cr "$VERDACCIO_DIR"
    echo "已移除 $VERDACCIO_DIR 的扩展属性"
fi
echo "$VERDACCIO_DIR 权限为 755"

# 4. 设置 storage 目录所有权和权限
echo "设置 $STORAGE_DIR 的权限..."
chmod 777 "$STORAGE_DIR"
if [ "$OS_TYPE" = "Darwin" ]; then
    xattr -c "$STORAGE_DIR"
    echo "已移除 $STORAGE_DIR 的扩展属性"
fi
echo "$STORAGE_DIR 权限为 777"

# 5. 执行 docker compose
echo "开始执行 docker compose..."
if ! docker compose up; then
   

 echo "错误：docker compose 启动失败"
    exit 1
fi
echo "Docker compose 成功启动"