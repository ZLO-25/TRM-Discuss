#!/usr/bin/env bash
# 建置 + 加密 TRM 學習網站，輸出到這個 repo 的根目錄（只輸出加密後的 index.html）。
# 用法：tools/publish.sh <本機 app/ 資料夾路徑>
# 密碼：設環境變數 STATICRYPT_PASSWORD，或不設、執行時會提示輸入。密碼絕不寫進任何檔案。
set -euo pipefail
APP="${1:?請給 app/ 資料夾路徑}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# 1. 複製一份 app（不動本機原檔），換成 Pages 用的入口與設定
rsync -a --exclude node_modules --exclude dist --exclude dist-pages --exclude shots "$APP/" "$WORK/app/"
cp "$REPO/tools/vite.pages.config.ts" "$WORK/app/"
cp "$REPO/tools/main.pages.tsx" "$WORK/app/src/"
sed -i.bak 's#/src/main.tsx#/src/main.pages.tsx#' "$WORK/app/index.html"

# 2. 建置成單一 HTML（明文只存在暫存資料夾）
( cd "$WORK/app" && npm ci --no-audit --no-fund && npm i -D vite-plugin-singlefile --no-audit --no-fund \
  && npx vite build -c vite.pages.config.ts )

# 3. 加密：用 repo 內固定的 salt（.staticrypt.json），這樣更新後「記住我」仍有效
( cd "$REPO" && npx -y staticrypt@3 "$WORK/app/dist-pages/index.html" -d "$WORK/enc" --short --remember 30 \
  -c .staticrypt.json \
  --template-title "TRM 學習工具" --template-instructions "請輸入密碼" --template-button "進入" \
  --template-placeholder "密碼" --template-remember "記住我(30 天)" --template-error "密碼錯誤" \
  --template-color-primary "#d4a24c" --template-color-secondary "#0f0f12" )
cp "$WORK/enc/index.html" "$REPO/index.html"

# 4. 安全檢查：加密檔裡不應出現任何中文明文內容
if grep -q "學習總覽\|閃卡" "$REPO/index.html"; then echo "警告：index.html 似乎含明文，停止" >&2; exit 1; fi
echo "完成：$REPO/index.html 已更新（加密）。檢查後 git add index.html && git commit && git push"
