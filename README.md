# TRM 學習工具(加密版)

網址:https://zlo-25.github.io/TRM-Discuss/

這個 repo 只放**加密後**的網站。書的內容、講稿、題庫原文都不在這裡,沒有密碼只會看到密碼輸入頁。

| 檔案 | 用途 |
|---|---|
| `index.html` | 用 StatiCrypt(AES-256 + PBKDF2)加密後的整個網站 |
| `.staticrypt.json` | 加密用的 salt(不是密碼,公開沒關係;固定它可讓「記住我」在更新後仍有效) |
| `tools/publish.sh` | 從本機 `app/` 重新建置並加密 |
| `tools/vite.pages.config.ts`, `tools/main.pages.tsx` | Pages 版的建置設定(單一 HTML、不用 PWA) |

## 更新網站

```bash
# 需要 Node.js。密碼可用環境變數給,或不給、執行時再輸入。
STATICRYPT_PASSWORD='你的密碼' tools/publish.sh "/path/to/red pill discuss/app"
git add index.html && git commit -m "Update site" && git push
```

密碼絕對不要寫進任何檔案或 commit。
