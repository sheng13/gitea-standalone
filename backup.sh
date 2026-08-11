#!/usr/bin/env bash
# 备份数据库、资料与用户仓库。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
TARGET="$ROOT_DIR/backups/gitea-$STAMP.tar.gz"
mkdir -p "$ROOT_DIR/backups"
for item in app.ini gitea.db data repos; do [[ -e "$ROOT_DIR/$item" ]] || { echo "缺少 $item"; exit 1; }; done
tar -C "$ROOT_DIR" -czf "$TARGET" app.ini gitea.db data repos
sha256sum "$TARGET" > "$TARGET.sha256"
chmod 0600 "$TARGET" "$TARGET.sha256"
echo "备份完成：$TARGET"
