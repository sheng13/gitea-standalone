#!/usr/bin/env bash
# 管理服务并安全建立管理员。
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE="gitea-standalone.service"
SERVICE_DIR="$HOME/.config/systemd/user"

install_service() {
  mkdir -p "$SERVICE_DIR"
  sed "s|__WORK_DIR__|$ROOT_DIR|g" "$ROOT_DIR/gitea.service.example" > "$SERVICE_DIR/$SERVICE"
  systemctl --user daemon-reload
  systemctl --user enable "$SERVICE"
}

case "${1:-}" in
  start) [[ -f "$SERVICE_DIR/$SERVICE" ]] || install_service; systemctl --user start "$SERVICE" ;;
  stop) systemctl --user stop "$SERVICE" ;;
  restart) systemctl --user restart "$SERVICE" ;;
  status) systemctl --user status "$SERVICE" --no-pager ;;
  log) journalctl --user -u "$SERVICE" -f ;;
  adduser)
    [[ -n "${2:-}" && -n "${3:-}" ]] || { echo "用法：manage.sh adduser 用户名 邮箱"; exit 1; }
    read -rsp "管理员密码：" password; echo
    "$ROOT_DIR/gitea" admin user create --admin --username "$2" --email "$3" --password "$password" --config "$ROOT_DIR/app.ini" --must-change-password=false
    unset password ;;
  *) echo "用法：manage.sh [start|stop|restart|status|log|adduser 用户名 邮箱]" ;;
esac
