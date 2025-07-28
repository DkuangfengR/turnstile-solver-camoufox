# 使用Python 3.12的官方镜像
FROM python:3.12-slim

# 设置工作目录
WORKDIR /app

# 安装必要的系统依赖
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 克隆仓库（方式1：直接克隆）
RUN git clone https://github.com/Theyka/Turnstile-Solver.git .

# 或者方式2：使用ADD直接下载并解压（更快）
# ADD https://github.com/Theyka/Turnstile-Solver/archive/refs/heads/main.tar.gz /tmp/
# RUN tar -xzf /tmp/main.tar.gz -C /app --strip-components=1 && rm /tmp/main.tar.gz

# 复制启动脚本（如果存在）
COPY entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

# 安装Python依赖
# 在Docker中不需要虚拟环境，因为容器本身就是隔离的
RUN pip install --no-cache-dir -r requirements.txt

# 执行camoufox fetch
RUN python -m camoufox fetch

# 安装camoufox依赖
RUN playwright install-deps

# 设置环境变量（可选）
ENV PYTHONUNBUFFERED=1

# 设置默认环境变量（根据官方文档）
ENV HEADLESS=True \
    BROWSER_TYPE=camoufox \
    DEBUG=False \
    THREAD=10 \
    HOST=0.0.0.0 \
    PORT=5000 \
    USERAGENT="" \
    PROXY=False

# 暴露端口
EXPOSE ${PORT}

# 运行应用
ENTRYPOINT ["/app/entrypoint.sh"]
