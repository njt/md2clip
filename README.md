# md2clip

A Claude Code skill that copies Claude's last response to the Windows clipboard as rich text. Paste into Word, Teams, or Outlook and get proper formatting — bold, headers, lists, tables, code blocks — instead of raw markdown.

## Install

```bash
git clone https://github.com/natfaulk/md2clip.git
cd md2clip
./install.sh
```

This copies the skill files to `~/.claude/skills/richcopy/`.

## Usage

In Claude Code, after any response:

```
/richcopy
```

Claude converts its last response from markdown to HTML with inline styles, then uses a PowerShell script to set the Windows clipboard with the CF_HTML format. Paste anywhere that accepts rich text.

You can also copy a subset:

```
/richcopy just the table
/richcopy the code block
```

## Requirements

- Claude Code
- Windows (PowerShell 5.1+ with .NET Framework)
- Works from both Git Bash and WSL

## How it works

Two files:

- **SKILL.md** — The Claude Code skill definition. Tells Claude how to convert its markdown response to HTML and invoke the clipboard script.
- **Set-HtmlClipboard.ps1** — PowerShell script that takes an HTML file, wraps it in the Windows CF_HTML clipboard format, and sets the clipboard via .NET `System.Windows.Forms.Clipboard`. Uses a UTF-8 `MemoryStream` to avoid encoding issues with non-ASCII characters (em dashes, etc.).

## License

MIT
