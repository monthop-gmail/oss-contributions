# OSS Contributions

Open Source Contributions - Bug reports, fixes, and technical analysis.

## Contributions

| Project | Issue | Status | Description |
|---------|-------|--------|-------------|
| [Claude Code](https://github.com/anthropics/claude-code) | [#21149](https://github.com/anthropics/claude-code/issues/21149) | Reported | Thai vowels (สระอา, สระอำ) not displaying |
| [OpenCode](https://github.com/anomalyco/opencode) | [opencode-line](https://github.com/monthop-gmail/opencode-line) | Released | LINE Messaging API integration for OpenCode AI coding agent |

## Structure

```
oss-contributions/
├── README.md
└── claude-code-thai-vowel-fix/
    ├── SUMMARY.md              # Overview and links
    ├── BUG_REPORT.md           # Detailed bug report
    ├── FIX_DESCRIPTION.md      # Technical fix description
    ├── thai-vowel-fix.sh       # Script to apply fix
    └── thai-vowel-fix-revert.sh # Script to revert fix
```

## Quick Fix Scripts

สคริปต์สำหรับแก้ปัญหาสระอา (า) และสระอำ (ำ) แสดงผลไม่ถูกต้องใน Claude Code

### Apply Fix
```bash
cd claude-code-thai-vowel-fix
./thai-vowel-fix.sh
```

### Revert Fix
```bash
./thai-vowel-fix-revert.sh
```

### Notes
- ใช้ `./script.sh` หรือ `bash script.sh` (ห้ามใช้ `sh script.sh`)
- ไม่ต้องใช้ `sudo` ถ้าติดตั้ง Node.js ผ่าน nvm
- ต้องรันใหม่หลัง `claude update`

## About

This repository contains my contributions to open source projects including:
- Bug reports with technical analysis
- Proposed fixes with code samples
- Documentation and summaries

---

*Contributions by [@monthop-gmail](https://github.com/monthop-gmail)*
