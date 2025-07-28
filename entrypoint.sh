#!/bin/bash
# docker-entrypoint.sh - 智能启动脚本

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Turnstile Solver Starting...      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"

# 设置默认值
BROWSER_TYPE=${BROWSER_TYPE:-chromium}
HEADLESS=${HEADLESS:-False}
DEBUG=${DEBUG:-False}
THREAD=${THREAD:-1}
HOST=${HOST:-127.0.0.1}
PORT=${PORT:-5000}
PROXY=${PROXY:-False}

# 构建命令
CMD="python api_solver.py"

# 添加浏览器类型
CMD="$CMD --browser_type ${BROWSER_TYPE}"
echo -e "${GREEN}BROWSER_TYPE: ${BROWSER_TYPE}${NC}"

# 处理headless模式
CMD="$CMD --headless ${HEADLESS}"
if [ "$HEADLESS" = "True" ]; then
    echo -e "${GREEN}HEADLESS: True${NC}"
    # 检查是否需要设置useragent（camoufox不需要）
    if [ "$BROWSER_TYPE" != "camoufox" ] && [ -z "$USERAGENT" ]; then
        echo -e "${YELLOW}WARNING: Specifies a custom User-Agent string for the browser. (No need to set if camoufox used)${NC}"
        USERAGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        echo -e "${YELLOW}Using Default User-Agent: ${USERAGENT}${NC}"
    fi
else
    echo -e "${GREEN}HEADLESS: False${NC}"
fi

# 添加其他必需参数
CMD="$CMD --host ${HOST}"
CMD="$CMD --port ${PORT}"
CMD="$CMD --thread ${THREAD}"
echo -e "${GREEN}Listening address: ${HOST}:${PORT}${NC}"
echo -e "${GREEN}Browser threads: ${THREAD}${NC}"

# 处理调试模式
if [ "$DEBUG" = "True" ]; then
    CMD="$CMD --debug ${DEBUG}"
    echo -e "${YELLOW}DEBUG MODE: True${NC}"
fi

# 处理User-Agent
if [ ! -z "$USERAGENT" ]; then
    CMD="$CMD --useragent \"${USERAGENT}\""
    echo -e "${GREEN}User-Agent: ${USERAGENT}${NC}"
fi

# 处理代理（boolean值，表示是否使用proxies.txt）
if [ "$PROXY" = "True" ]; then
    CMD="$CMD --proxy ${PROXY}"
    echo -e "${GREEN}PROXY MODE: Select a random proxy from proxies.txt for solving captchas${NC}"
    # 检查proxies.txt是否存在
    if [ ! -f "/app/proxies.txt" ]; then
        echo -e "${YELLOW}WARNING: proxies.txt doesn't exist${NC}"
    fi
fi

# 显示最终命令
echo -e "\n${BLUE}Run Command:${NC}"
echo -e "${GREEN}$CMD${NC}\n"

# 处理信号
trap 'echo -e "\n${RED}Received termination signal, closing now${NC}"; kill $PID; exit 0' SIGTERM SIGINT

# 执行命令
eval $CMD &
PID=$!

# 等待进程启动
sleep 2

# 显示服务信息
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Service is running              ║${NC}"
echo -e "${BLUE}╟────────────────────────────────────────╢${NC}"
echo -e "${BLUE}║ Running on: http://${HOST}:${PORT}       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"

# 等待进程
wait $PID
