#!/bin/bash
# install.sh — Install the richcopy skill for Claude Code
# Works from Git Bash (Windows) and WSL

set -e

SKILL_DIR="$HOME/.claude/skills/richcopy"

mkdir -p "$SKILL_DIR"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
cp "$SCRIPT_DIR/Set-HtmlClipboard.ps1" "$SKILL_DIR/Set-HtmlClipboard.ps1"

echo "Installed richcopy skill to $SKILL_DIR"
echo "Use /richcopy in Claude Code to copy the last response as rich text."
