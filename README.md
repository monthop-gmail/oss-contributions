# OSS Contributions

Open Source Contributions - Bug reports, fixes, and technical analysis.

## Contributions

| Project | Issue | Status | Description |
|---------|-------|--------|-------------|
| [Claude Code](https://github.com/anthropics/claude-code) | [#21149](https://github.com/anthropics/claude-code/issues/21149) | Reported | Thai vowels (สระอา, สระอำ) not displaying |
| [OpenCode](https://github.com/anomalyco/opencode) | [#13801](https://github.com/anomalyco/opencode/issues/13801) / [PR #13799](https://github.com/anomalyco/opencode/pull/13799) / [opencode-line](https://github.com/monthop-gmail/opencode-line) | CI Passed | LINE Messaging API integration for OpenCode AI coding agent |
| [Claude Code](https://github.com/anthropics/claude-code) | [claude-code-line](https://github.com/monthop-gmail/claude-code-line) | Released | LINE Messaging API bridge for Claude Code CLI |

## Structure

```
oss-contributions/
├── README.md
├── claude-code-thai-vowel-fix/
│   ├── SUMMARY.md              # Overview and links
│   ├── BUG_REPORT.md           # Detailed bug report
│   ├── FIX_DESCRIPTION.md      # Technical fix description
│   ├── thai-vowel-fix.sh       # Script to apply fix
│   └── thai-vowel-fix-revert.sh # Script to revert fix
├── opencode-line-integration/
│   └── SUMMARY.md              # Overview, links, architecture
└── claude-code-line-integration/
    └── SUMMARY.md              # Overview, links, architecture
```

## Claude Code Thai Vowel Fix

สคริปต์สำหรับแก้ปัญหาสระอา (า) และสระอำ (ำ) แสดงผลไม่ถูกต้องใน Claude Code

```bash
cd claude-code-thai-vowel-fix
./thai-vowel-fix.sh        # Apply fix
./thai-vowel-fix-revert.sh # Revert fix
```

**Notes:**
- ใช้ `./script.sh` หรือ `bash script.sh` (ห้ามใช้ `sh script.sh`)
- ไม่ต้องใช้ `sudo` ถ้าติดตั้ง Node.js ผ่าน nvm
- ต้องรันใหม่หลัง `claude update`

## OpenCode LINE Integration

LINE Messaging API integration สำหรับ OpenCode AI coding agent

| Version | Description | Run |
|---------|-------------|-----|
| [PR #13799](https://github.com/anomalyco/opencode/pull/13799) | Monorepo (`@opencode-ai/sdk`) | `cd packages/line && bun dev` |
| [opencode-line](https://github.com/monthop-gmail/opencode-line) | Standalone (Docker Compose) | `docker compose up -d` |

See [SUMMARY.md](opencode-line-integration/SUMMARY.md) for details.

## Claude Code LINE Integration

LINE Messaging API bridge สำหรับ Claude Code CLI

| Repo | Description | Run |
|------|-------------|-----|
| [claude-code-line](https://github.com/monthop-gmail/claude-code-line) | Docker Compose (node + bun + claude CLI) | `docker compose up -d` |

See [SUMMARY.md](claude-code-line-integration/SUMMARY.md) for details.

## About

This repository contains my contributions to open source projects including:
- Bug reports with technical analysis
- Proposed fixes with code samples
- Documentation and summaries

---

*Contributions by [@monthop-gmail](https://github.com/monthop-gmail)*
