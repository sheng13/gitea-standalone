# 公司小團隊 Git 平台（Gitea）說明

這個資料夾就是整個 Git 平台的全部內容。
備份、搬家時，只要把「這個資料夾整個」打包帶走即可。

## 網址
- 區網內瀏覽器開： http://<PRIVATE_IP>:3000
- 管理員帳號：admin / <CHANGE_ME>（請登入後立刻改密碼）

## 資料夾內容
- gitea            平台程式本體（直接執行，非 Docker）
- app.ini          平台設定檔（埠號、網址、資料庫等）
- gitea.db.sqlite.bak  遷移前的 SQLite 備份（回退用，平時可忽略）
- repos/           同事的程式專案實際檔案
- data/            Gitea 內部資料
- log/             運作日誌
- gitea.service    systemd 開機自啟服務定義（目前 demo 用，非 Docker）
- setup_postgres.sh   安裝/初始化 PostgreSQL 的腳本（sudo 跑，只需一次）
- docker-compose.云端版.yml   上公司云用的 Docker 范本（Gitea + PostgreSQL，IT 直接起）
- 部署到公司云_申请与部署说明.md  给 IT/主管的申请与部署文档
- manage.sh        管理小抄（啟動/停止/加帳號）
- *.png            首頁/登入頁/儀表板 截圖
- .secret_key / .internal_token   安全密鑰（勿外洩）

## 備份 / 搬家（注意：現在資料在 PostgreSQL，不只檔案）
1. 先停服務： bash manage.sh stop
2. 備份 PostgreSQL 資料：`PGPASSWORD=<CHANGE_ME> pg_dump -h 127.0.0.1 -U gitea gitea > gitea-postgres.sql`
3. 打包檔案：   tar czf gitea-backup.tar.gz -C ~ gitea-standalone
4. 搬到新機器：先裝好 PostgreSQL 並建好 gitea/gitea，匯入 gitea-postgres.sql，解開檔案包，
   重新啟用服務：
   ln -sf /opt/gitea-standalone/gitea.service ~/.config/systemd/user/gitea.service
   systemctl --user daemon-reload && systemctl --user enable --now gitea.service
  bash manage.sh status    看是否在跑
  bash manage.sh restart   重啟
  bash manage.sh stop      停止
  bash manage.sh start     啟動
  bash manage.sh log       看日誌
  bash manage.sh adduser 使用者名 密碼   加同事帳號

## 備份 / 搬家
1. 先停服務： bash manage.sh stop
2. 打包：     tar czf gitea-backup.tar.gz -C ~ gitea-standalone
3. 搬到新機器解開，重新建立 symlink 並啟用服務：
   ln -sf /opt/gitea-standalone/gitea.service ~/.config/systemd/user/gitea.service
   systemctl --user daemon-reload && systemctl --user enable --now gitea.service
