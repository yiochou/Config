---
description: 自由對話發想,結束時 (/noodle end) 總結存檔到 ~/Projects/noodle 並 push
---

指令參數:$ARGUMENTS

筆記本 repo 位置固定在 `~/Projects/noodle`(結構:`README.md`、`INDEX.md`、`notes/`)。

## 如果參數是 `end`

執行「結束並存檔」流程:

1. 回顧這次對話中,從最近一次 `/noodle <主題>` 開始到現在的討論內容。
2. 產生一份總結草稿,包含:
   - `title`:主題標題
   - `description`:一句話摘要,方便日後搜尋比對
   - `tags`:幾個關鍵字
   - 討論摘要(prose 或條列皆可)
   - 重點 / 決定
   - 待辦 / 開放問題(如果有)
3. 把草稿完整顯示給使用者看,**先不要寫檔**。明確詢問使用者是否核准,或需要修改。
4. 使用者核准後:
   a. 檔名格式:`YYYY-MM-DD-<slug>.md`(slug 是根據主題產生的簡短 kebab-case 英文字串;若同一天已有相同檔名,slug 加上區分後綴)。
   b. 寫入 `~/Projects/noodle/notes/<檔名>`,frontmatter 包含:
      ```yaml
      ---
      date: <完整 ISO 時間,含時分>
      title: <title>
      description: <description>
      tags: [tag1, tag2]
      continued_from: null   # 若本次討論有明確參考到某篇舊筆記,填入該筆記相對於 notes/ 的檔名;否則為 null
      ---
      ```
      內文照第 2 步的結構(討論摘要 / 重點決定 / 待辦與開放問題)。
   c. 更新 `~/Projects/noodle/INDEX.md` 的表格,新增一列(Date | Title | Description | Tags | File | Continued From),依日期附加在表格最後。
   d. `cd ~/Projects/noodle && git add -A && git commit -m "<title>" && git push`
   e. 完成後跟使用者確認檔案路徑與 commit/push 是否成功。

## 如果參數是主題或關鍵字(不是 `end`)

開啟自由對話模式:

- 直接針對「$ARGUMENTS」開始討論。**不需要固定的引導流程**(不用一次只問一題、不用刻意收斂成設計文件),自然來回聊就好。
- **不要**主動去 `~/Projects/noodle` 搜尋或參考任何舊筆記,除非使用者在對話中明確要求「參考之前討論過的 XXX」。
- 如果使用者明確要求參考舊討論:
  1. 到 `~/Projects/noodle/INDEX.md` 找符合關鍵字的列(比對 title / description / tags)。
  2. 讀取對應的 `notes/*.md` 檔案全文,把內容當作背景脈絡,融入接下來的討論。
  3. 之後若這次討論存檔,在新筆記的 frontmatter `continued_from` 填入該舊筆記的檔名。
- 持續自由對話,直到使用者呼叫 `/noodle end`。

## 如果沒有參數

提醒使用者需要提供主題,例如 `/noodle <想討論的主題>`,或用 `/noodle end` 結束並存檔目前討論。
