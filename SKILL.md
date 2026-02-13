---
name: richcopy
description: Copy the last response as rich text to clipboard for pasting into Word, Teams, Outlook, etc.
---

Take your most recent response (immediately before this command) and copy it to the Windows clipboard as rich text so it pastes into Word, Teams, and Outlook with proper formatting (bold, headers, lists, tables, code blocks — no raw markdown).

If $ARGUMENTS is provided, only copy the portion matching that description (e.g. `/richcopy just the table`).

## Steps

1. Convert your previous response from Markdown to HTML:
   - Use proper semantic tags: `<strong>`, `<em>`, `<h1>`–`<h6>`, `<ul>`/`<ol>`/`<li>`, `<pre><code>`, `<table>`, `<a>`, `<blockquote>`
   - Use **inline CSS styles** (no classes/external stylesheets — clipboard HTML has no stylesheet support)
   - Code blocks: `style="background-color:#f4f4f4; padding:8px; border-radius:4px; font-family:Consolas,monospace; white-space:pre-wrap; font-size:13px"`
   - Tables: `border-collapse:collapse` on `<table>`, `border:1px solid #ccc; padding:6px` on `<td>`/`<th>`, bold `<th>` with light background
   - Blockquotes: `style="border-left:3px solid #ccc; padding-left:12px; color:#555; margin:8px 0"`
   - Paragraphs: wrap text blocks in `<p>` tags
   - Do NOT include `<html>`, `<head>`, or `<body>` wrapper tags — the clipboard script adds those

2. Write the HTML to a temp file using the Write tool. Use path `/tmp/richcopy.html`.

3. Run the clipboard script:
   ```bash
   SCRIPT=$(cygpath -w ~/.claude/skills/richcopy/Set-HtmlClipboard.ps1 2>/dev/null || wslpath -w ~/.claude/skills/richcopy/Set-HtmlClipboard.ps1 2>/dev/null)
   HTMLFILE=$(cygpath -w /tmp/richcopy.html 2>/dev/null || wslpath -w /tmp/richcopy.html 2>/dev/null)
   powershell.exe -STA -NoProfile -File "$SCRIPT" -Path "$HTMLFILE"
   ```

4. Tell the user the content has been copied as rich text.
