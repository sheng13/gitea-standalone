#!/usr/bin/env bash
# 下载 Gitea 并从模板产生仅限本机使用的配置。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITEA_VERSION="${GITEA_VERSION:-1.27.0}"
ARCH="${GITEA_ARCH:-linux-amd64}"
DOMAIN="${GITEA_DOMAIN:-127.0.0.1}"
RUN_USER="$(id -un)"
URL="https://dl.gitea.com/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-${ARCH}"

command -v curl >/dev/null || { echo "需要 curl"; exit 1; }
command -v openssl >/dev/null || { echo "需要 openssl"; exit 1; }
mkdir -p "$ROOT_DIR"/{data,log,repos,backups}

if [[ ! -x "$ROOT_DIR/gitea" ]]; then
  curl -fL "$URL" -o "$ROOT_DIR/gitea"
  chmod 0755 "$ROOT_DIR/gitea"
fi

if [[ ! -f "$ROOT_DIR/app.ini" ]]; then
  sed -e "s|__RUN_USER__|$RUN_USER|g" -e "s|__WORK_DIR__|$ROOT_DIR|g" \
      -e "s|__DOMAIN__|$DOMAIN|g" \
      -e "s|__SECRET_KEY__|$(openssl rand -hex 32)|g" \
      -e "s|__INTERNAL_TOKEN__|$(openssl rand -hex 32)|g" \
      -e "s|__JWT_SECRET__|$(openssl rand -hex 32)|g" \
      "$ROOT_DIR/app.ini.example" > "$ROOT_DIR/app.ini"
  chmod 0600 "$ROOT_DIR/app.ini"
fi

echo "安装完成：bash manage.sh start"
echo "访问：http://${DOMAIN}:3000/"
