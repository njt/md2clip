---
name: richcopy
description: Copy the last response as rich text to clipboard for pasting into Word, Teams, Outlook, etc.
---

Copy a response to the Windows clipboard as rich text so it pastes into Word, Teams, and Outlook with proper formatting (bold, headers, lists, tables, code blocks — no raw markdown).

## Which response to copy

Interpret $ARGUMENTS to decide what to copy:

- **No arguments** (`/richcopy`): Copy your most recent response (immediately before this command).
- **A number** (`/richcopy 3`): Copy the Nth-most-recent assistant response, counting back from the latest. `/richcopy 1` = latest, `/richcopy 3` = third-most-recent.
- **`pick`** (`/richcopy pick`): Present an interactive chooser. Show the 4 most recent assistant responses as options using AskUserQuestion, with a one-line summary of each (first ~60 characters). Include an "Older..." option. If the user picks "Older...", show the next 4. Repeat until they choose one.
- **Descriptive text** (`/richcopy just the table`): Copy only the portion of the most recent response matching that description.

## Steps

1. Identify the target response using the rules above.

2. Convert it from Markdown to HTML:
   - Use proper semantic tags: `<strong>`, `<em>`, `<h1>`–`<h6>`, `<ul>`/`<ol>`/`<li>`, `<pre><code>`, `<table>`, `<a>`, `<blockquote>`
   - Use **inline CSS styles** (no classes/external stylesheets — clipboard HTML has no stylesheet support)
   - Code blocks: `style="background-color:#f4f4f4; padding:8px; border-radius:4px; font-family:Consolas,monospace; white-space:pre-wrap; font-size:13px"`
   - Tables: `border-collapse:collapse` on `<table>`, `border:1px solid #ccc; padding:6px` on `<td>`/`<th>`, bold `<th>` with light background
   - Blockquotes: `style="border-left:3px solid #ccc; padding-left:12px; color:#555; margin:8px 0"`
   - Paragraphs: wrap text blocks in `<p>` tags
   - Do NOT include `<html>`, `<head>`, or `<body>` wrapper tags — the clipboard script adds those

3. Write the HTML to a temp file using the Write tool. Use path `/tmp/richcopy.html`.

4. Run the clipboard script:
   ```bash
   SCRIPT=$(cygpath -w ~/.claude/skills/richcopy/Set-HtmlClipboard.ps1 2>/dev/null || wslpath -w ~/.claude/skills/richcopy/Set-HtmlClipboard.ps1 2>/dev/null)
   HTMLFILE=$(cygpath -w /tmp/richcopy.html 2>/dev/null || wslpath -w /tmp/richcopy.html 2>/dev/null)
   powershell.exe -STA -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT" -Path "$HTMLFILE"
   ```

5. Tell the user the content has been copied as rich text.
