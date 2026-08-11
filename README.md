# Gitea Standalone

适合小团队、课程实验与内网环境的 Gitea 单机部署范例。采用 SQLite，不需要额外数据库服务。

> 本仓库只保存部署脚本、示例配置与说明，不保存数据库、用户仓库、日志、Token、私钥或 Gitea 二进制。

## 功能

- Gitea + SQLite 单机部署
- systemd user service
- 服务管理、管理员建立与备份
- 局域网访问
- 安全配置示例与完整 `.gitignore`

## 快速开始

```bash
git clone https://github.com/sheng13/gitea-standalone.git
cd gitea-standalone
bash install.sh
bash manage.sh start
```

打开 `http://127.0.0.1:3000/`。同一局域网设备使用 `http://电脑IP:3000/`，可用 `hostname -I` 查询 IP。

## 建立管理员

```bash
bash manage.sh adduser admin admin@example.com
```

脚本会提示输入密码，不会把密码写入命令历史。

## 备份

```bash
bash backup.sh
```

备份保存在被 Git 忽略的 `backups/`，请另外复制到安全储存位置。

## 项目结构

```text
app.ini.example       安全配置模板
install.sh            下载与初始化
manage.sh             服务与账号管理

## 分类文档

Gitea 教学、云端部署与界面截图已分开放置，请查看 [docs/README.md](docs/README.md)。

backup.sh             备份与校验
gitea.service.example systemd user service
docs/                  界面截图
```

## 安全提醒

- 不要提交 `app.ini`、数据库、Token、私钥、日志、备份或用户仓库。
- 对外服务请配置 HTTPS、反向代理和防火墙。
- 定期验证备份能否恢复。
