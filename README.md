# richcopy

Claude Code's built-in `/copy` command copies responses as plain Markdown. That's fine for pasting into code editors or Markdown-aware tools, but when you paste into Microsoft Teams, Word, Outlook, or other rich text applications, you see raw Markdown syntax instead of formatted text.

`/richcopy` converts the Markdown to HTML and places it on the clipboard as rich text (CF_HTML format). When you paste, headings, bold, tables, code blocks, and lists render as properly formatted content — not as `**asterisks**` and `|pipes|`.

Works from both WSL and native Windows environments.

## Install

```bash
git clone https://github.com/njt/md2clip.git
cd md2clip
./install.sh
```

This copies the skill files to `~/.claude/skills/richcopy/`.

## Usage

```
/richcopy              # copy the last response
/richcopy 3            # copy the 3rd-most-recent response
/richcopy pick         # interactively choose from recent responses
/richcopy just the table   # copy only part of the last response
```

## Requirements

- Claude Code
- Windows (PowerShell 5.1+ with .NET Framework)
- Works from both Git Bash and WSL

## How it works

Two files:

- **SKILL.md** — The Claude Code skill definition. Tells Claude how to convert its Markdown response to HTML and invoke the clipboard script.
- **Set-HtmlClipboard.ps1** — PowerShell script that takes an HTML file, wraps it in the Windows CF_HTML clipboard format, and sets the clipboard via .NET `System.Windows.Forms.Clipboard`. Uses a UTF-8 `MemoryStream` to avoid encoding issues with non-ASCII characters (em dashes, etc.).

## License

MIT
