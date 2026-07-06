---
description: 從一句話點子建立資料夾、本機 git repo、GitHub repo,交給 brainstorming 產生設計 spec,核准並正式命名後,再交給 writing-plans 產出實作計畫
---

指令參數:$ARGUMENTS

參數是一句話點子,例如 `/new-project 一個把螢幕截圖丟去 OCR 的小工具`。若沒有參數,提醒使用者需要提供一句話點子。

## 整體流程

### 1. Bootstrap

1. 用目前時間戳產生一個臨時 slug:`tmp-YYYYMMDD-HHMM`。
2. `mkdir -p ~/projects/<slug> && cd ~/projects/<slug> && git init`。
3. 問使用者這次 repo 要 public 還是 private(使用者沒有偏好時預設 private)。
4. 寫入骨架檔案:
   - `README.md`(英文):

     ```markdown
     # <slug>

     <使用者給的一句話點子原文>

     ## Status

     🚧 Brainstorming
     ```

   - `.gitignore`:內容為單獨一行 `docs/superpowers/`
   - `LICENSE`:標準 MIT 授權文字,著作權人 `Yio`,年份為當年
5. `git add -A && git commit -m "chore: scaffold project"`。
6. `gh repo create <slug> --public|--private --source=. --remote=origin --push`(依步驟 3 選的可見度)。

### 2. 腦暴

在剛建立的專案目錄裡,呼叫 `superpowers:brainstorming`,把使用者的一句話點子當作起始輸入,讓它照原本的流程走(一問一答、提方案、分段呈現設計、使用者核准)。

**覆蓋它的兩個預設行為:**

1. 它原本會把 spec 寫到 `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md` 之後直接 commit——這裡改成只寫檔、不 commit(反正 `.gitignore` 也會擋掉,保持 spec 只留在本機)。
2. 它內建的 User Review Gate 訊息會說 spec 已經「committed」,這裡改成:「Spec written to `<path>`. Please review it and let me know if you want to make any changes before we rename the project and move on to writing the implementation plan.」——因為沒有 commit,也順便提到接下來會先 rename 才寫 plan。
3. 使用者核准 spec 之後,**不要**讓 brainstorming 自動接著呼叫 `writing-plans`(它原本的 terminal state 就是這麼做)。停在這裡,交回控制權給下面的「3. 正式命名 + Rename」。

### 3. 正式命名 + Rename

使用者核准 spec 後:

1. 根據最終設計提議一個正式的英文 kebab-case 專案名稱,讓使用者確認(或自己給一個名字)。
2. `mv ~/projects/<slug> ~/projects/<new-name>`。
3. `cd ~/projects/<new-name>`,然後 `gh repo rename <new-name>`(在 repo 目錄內執行,會自動把本機 `origin` remote URL 一起更新)。如果因為名字被佔用而失敗,跟使用者要一個不同的名字重試。
4. 重寫 `README.md`(英文,反映「目前專案的樣子」,不要連結任何 spec/plan 檔案路徑,因為那些檔案不會被 commit):

   ```markdown
   # <new-name>

   <一句話 tagline>

   ## Status

   📝 Design approved, not yet implemented

   ## Motivation

   <用自己的話摘要為什麼要做這個、打算怎麼做>
   ```

5. `git add -A && git commit -m "docs: update README with approved design" && git push`。

### 4. 實作計畫

呼叫 `superpowers:writing-plans`,產出 `docs/superpowers/plans/YYYY-MM-DD-<feature>.md`。同樣不 commit(被同一條 `.gitignore` 擋掉),等實作完成後可以直接刪除這份計畫檔案。

**覆蓋它的預設行為:** 計畫寫完存檔之後,**不要**讓它繼續進入自己的「Execution Handoff」步驟(也就是問「Subagent-Driven 還是 Inline Execution」、接著呼叫 `superpowers:subagent-driven-development` 或 `superpowers:executing-plans` 開始實作那一段)。整段跳過,計畫檔案就是這個指令的最終產出。

流程到此結束,交回給使用者,實際的程式實作留到下一次對話再進行。

## 錯誤處理

- `gh repo create` 失敗(認證過期、網路問題等):停下來告知使用者,本機 git 已經 init 好,可以之後手動補建 GitHub repo。
- `gh repo rename` 因為名字被佔用而失敗:跟使用者要一個不同的名字,重試步驟 3 的 rename。
- 使用者中途放棄腦暴:本機資料夾、臨時 repo 都保留原狀,不用自動清理,使用者可以自行刪除或之後再繼續。
