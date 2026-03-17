# ldocker-openclaw

![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![OpenClaw](https://img.shields.io/badge/OpenClaw-FF6B6B?style=flat)
![Node.js](https://img.shields.io/badge/Node.js-25.6-green?style=flat)
![License](https://img.shields.io/badge/License-MIT-green?style=flat)

在 Docker 中运行 OpenClaw 的完整解决方案，开箱即用。

## 📖 项目简介

docker-openclaw 是一个将 [OpenClaw](https://github.com/openclaw/openclaw) 封装为 Docker 容器的项目。通过 Docker Compose 可以快速部署 OpenClaw Gateway，无需手动安装 Node.js、Chrome、浏览器自动化工具等依赖。

### 主要特性

- 🚀 **一键部署** - Docker Compose 快速启动
- 🔒 **安全优先** - 内置审批机制，可配置自动批准
- 🌏 **国内优化** - npm + apt 镜像源加速
- 📱 **多渠道支持** - 飞书、企业微信、Telegram 等
- 🔧 **可扩展** - 支持自定义配置和工作空间

## 🏗️ 技术架构

| 组件       | 版本/说明                          |
| ---------- | ---------------------------------- |
| 基础镜像   | Node.js 25.6 + Debian Bookworm     |
| 操作系统   | Debian Bookworm                    |
| 浏览器支持 | Agent Browser (智能体浏览器自动化) |
| 进程管理   | SupervisorD                        |
| 虚拟显示   | Xvfb (无头浏览器支持)              |

### 内置功能

- ✅ OpenClaw Gateway
- ✅ Agent Browser (智能体浏览器自动化)
- ✅ 自动审批脚本 (自动批准本地连接)
- ✅ 国内镜像源 (npm + apt 加速)
- ✅ 飞书插件集成

## 🚀 快速开始

### 前置要求

- Docker Engine 20.10+
- Docker Compose V2

### 安装步骤

```bash
# 1. 克隆项目
git clone https://github.com/seekeyl/docker-openclaw.git
cd docker-openclaw

# 2. 配置环境变量
编辑 config/openclaw.json，配置你的 API url 和渠道
复制 docker-compose.yml 为 docker-compose_personal.yml，在后者配置你的 API key

# 3. 构建并运行
docker-compose -f docker-compose_personal.yml up -d

# 4. 新版启动的时候可能要在镜像内允许device
## 本地浏览器打开localhost/18789，并输入token，提示需要pairing
docker exec -it docker-openclaw /bin/bash openclaw devices approve

# 5. 查看日志
docker-compose logs -f
```

### 企业微信配置（docker内）

参照腾讯官方教程：

```
1. 在企微里用api长连接模式创建一个机器人bot；获取其QYWECHAT_BOT_ID及QYWECHAT_SECRET并配置到docker-compose_personal.yml文件中；
2. 在企微中与给机器人发一个消息，获取pairing code；
3. 进入openclaw 镜像中，docker exec -it docker-openclaw /bin/bash
4. 执行openclaw pairing approve wecom < pairing CODE>即可。
5. exit 退出openclaw镜像
```

每次docker compose up -d都需要从2开始重做。

注意：暂无法采用在dockerfile中使用 `npx -y @wecom/wecom-openclaw-cli install` 的方式来安装插件，因为这是一个这种方式是交互式插件安装，需要光标点击/扫码，无法在docker build时自动完成，会报错。

### 首次访问

| 服务    | 地址                           |
| ------- | ------------------------------ |
| Gateway | http://localhost:18789         |
| WebChat | http://localhost:18789/webchat |

> **注意**: WebChat 需要在 `docker-compose.yml` 中配置 `WEBCHAT_TOKEN` 环境变量

## ⚙️ 配置说明

### 环境变量

在 `docker-compose.yml` 中配置：

| 变量名                | 必填 | 默认值                 | 说明                      |
| --------------------- | ---- | ---------------------- | ------------------------- |
| `TZ`                | 否   | Asia/Shanghai          | 时区                      |
| `MINIMAX_API_KEY`   | 是   | -                      | MiniMax API Key           |
| `ALIYUNCS_API_KEY`  | 否   | -                      | 阿里云 API Key (备用模型) |
| `PRIMARY_MODEL`     | 否   | aliyuncs/qwen3.5-plus  | 主用模型                  |
| `PRIMARY_VL_MODEL`  | 否   | aliyuncs/qwen3-vl-plus | 视觉模型 (支持图片理解)   |
| `WEBCHAT_TOKEN`     | 否   | -                      | WebChat 访问令牌          |
| `FEISHU_APP_ID`     | 否   | -                      | 飞书应用 ID               |
| `FEISHU_APP_SECRET` | 否   | -                      | 飞书应用密钥              |

### 配置文件

配置文件挂载在 `config/openclaw.json`，可自定义配置项：

- 模型提供商配置
- 消息渠道 (飞书、企业微信、Telegram 等)
- 安全策略
- 执行审批规则
- 插件配置

详见 [OpenClaw 配置文档](https://docs.openclaw.ai/gateway/configuration)

### 切换模型

可通过环境变量灵活切换主用模型：

```bash
# 使用默认配置 (Qwen3.5 Plus + Qwen3-VL-Plus)
docker-compose up -d

# 使用 MiniMax 作为主模型
PRIMARY_MODEL=minimax/MiniMax-M2.5 docker-compose up -d

# 使用自定义模型组合
PRIMARY_MODEL=aliyuncs/qwen3.5-plus PRIMARY_VL_MODEL=aliyuncs/qwen3-vl-plus docker-compose up -d
```

### 配置文件示例

```json
{
  "models": {
    "providers": {
      "minimax": {
        "apiKey": "YOUR_API_KEY"
      }
    }
  },
  "channels": {
    "feishu": {
      "enabled": true,
      "accounts": {
        "default": {
          "appId": "YOUR_APP_ID",
          "appSecret": "YOUR_APP_SECRET"
        }
      }
    }
  }
}
```

## 📁 项目结构

```
docker-openclaw/
├── Dockerfile              # Docker 镜像构建文件
├── docker-compose.yml      # Docker Compose 编排文件
├── config/                 # 配置文件目录
│   └── openclaw.json      # OpenClaw 配置文件模板
├── workspace/              # 工作空间目录 (挂载到容器)
├── scripts/                # 自动审批脚本
│   ├── approve.sh         # 命令审批脚本
│   ├── approve-10s.sh     # 10秒自动审批循环
│   └── supervisord.conf  # Supervisor 配置
├── run.sh                  # Linux 运行脚本
├── run.bat                 # Windows 运行脚本
├── build.sh                # Linux 构建脚本
├── build.bat               # Windows 构建脚本
├── browser_approve.sh      # 浏览器审批脚本 (Linux)
├── browser_approve.bat     # 浏览器审批脚本 (Windows)
└── LICENSE                 # MIT 许可证
```

## 🔧 常用操作

### 容器管理

```bash
# 构建镜像
docker-compose build

# 后台启动
docker-compose up -d

# 查看状态
docker-compose ps

# 查看实时日志
docker-compose logs -f

# 查看实时日志 (仅 OpenClaw)
docker-compose logs -f openclaw

# 重启服务（可保持容器内的变化仍能使用，如更新openclaw） 
docker-compose restart

# 停止服务
docker-compose down

# 停止并删除卷
docker-compose down -v
```

### 进入容器调试

```bash
# 进入容器 Shell
docker exec -it docker-openclaw /bin/bash

# 查看 OpenClaw 状态
docker exec -it docker-openclaw openclaw status

# 查看待审批请求
docker exec -it docker-openclaw openclaw devices list
```

### 审批管理

```bash
# 手动审批所有待定请求
docker exec -it docker-openclaw openclaw devices approve --all

# 查看审批日志
docker exec -it docker-openclaw tail -f /tmp/openclaw-approve.log
```

## 🔐 安全说明

### 默认安全策略

- 默认配置下，危险命令需要审批
- 本地网络请求自动批准
- 远程请求需要手动审批

### 生产环境建议

1. **禁用自动审批** - 生产环境建议关闭 `approve-10s.sh`
2. **API Key 管理** - 使用 Docker secrets 或环境变量注入
3. **网络隔离** - 配置防火墙规则
4. **定期更新** - 关注 OpenClaw 最新版本

### 安全配置示例

```yaml
# docker-compose.yml
services:
  openclaw:
    environment:
      - WEBCHAT_TOKEN=${WEBCHAT_TOKEN}  # 使用 .env 文件
    # 限制容器能力
    security_opt:
      - no-new-privileges:true
    read_only: true  # 只读文件系统 (可选)
```

## 📦 镜像信息

| 项目     | 值                                       |
| -------- | ---------------------------------------- |
| 镜像名称 | docker-openclaw:latest                   |
| 暴露端口 | 18789 (Gateway)                          |
| 数据卷   | ./config → /root/.openclaw/             |
| 数据卷   | ./workspace → /root/.openclaw/workspace |

## 🤝 常见问题

### Q: 容器启动失败怎么办？

```bash
# 查看详细日志
docker-compose logs

# 检查端口是否被占用
netstat -tlnp | grep 18789
```

### Q: 如何更新 OpenClaw 版本？

```bash
# 重新构建镜像
docker-compose build

# 重启服务
docker-compose restart
```

### Q: 如何配置自定义模型？

在 `config/openclaw.json` 中添加模型配置：

```json
{
  "models": {
    "providers": {
      "openai": {
        "apiKey": "YOUR_KEY"
      }
    }
  }
}
```

### Q: 飞书消息收不到？

1. 检查 `FEISHU_APP_ID` 和 `FEISHU_APP_SECRET` 是否正确
2. 确认飞书应用已启用
3. 查看日志：`docker-compose logs | grep feishu`

## 🔗 相关链接

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [OpenClaw GitHub](https://github.com/openclaw/openclaw)
- [OpenClaw Discord](https://discord.com/invite/clawd)
- [ClawHub - Skills 市场](https://clawhub.ai)

## 📄 License

MIT License - see [LICENSE](LICENSE) file.

---

<p align="center">
  Made with ❤️ by Seekey
</p>
