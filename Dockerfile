# 基础镜像：Node.js 25.6 + Debian Bookworm
FROM node:25.6-bookworm

# 配置国内源
RUN npm config set registry https://registry.npmmirror.com/ \
    && sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources

# 安装系统依赖（包括 Chrome 所需库）
RUN apt update && apt upgrade -y 
RUN apt install -y \
       python3 python3-pip vim net-tools jq wget supervisor xvfb chromium \
       libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
       libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 \
       libxrandr2 libgbm1 libpango-1.0-0 libcairo2 libasound2

# # 安装 OpenClaw
# RUN npm i -g openclaw

# ===== 指定openclaw版本参数 =====
ARG OPENCLAW_VERSION=latest
# ARG OPENCLAW_VERSION=OpenClaw 2026.3.8

# ===== 安装 OpenClaw（构建时固定版本）=====
RUN if [ "$OPENCLAW_VERSION" = "latest" ]; then \
        npm i -g openclaw; \
    else \
        npm i -g "openclaw@${OPENCLAW_VERSION}"; \
    fi \
    && npm cache clean --force


# 安装 agent-browser，但不要用agent-browser下载 Chrome for Testing (官方不提供arm64版)
RUN npm install -g agent-browser
# 设置使用系统 Chromium
ENV AGENT_BROWSER_EXECUTABLE_PATH=/usr/bin/chromium

# 非交互式初始化配置
RUN yes "" | openclaw setup

# 飞书插件
RUN openclaw plugins install @openclaw/feishu
# 删除重复文件
RUN rm -rf /root/.openclaw/extensions/feishu

# 企微插件
RUN openclaw plugins install @wecom/wecom-openclaw-plugin@latest


# 暴露端口（仅 gateway 端口）
EXPOSE 18789

# 启动命令
CMD ["/bin/bash", "-c", "openclaw gateway --bind lan --port 18789 --allow-unconfigured"]