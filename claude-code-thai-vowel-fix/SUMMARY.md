# สรุปการวิเคราะห์ Bug ภาษาไทยใน Claude Code

**วันที่:** 4 กุมภาพันธ์ 2026
**Version:** Claude Code 2.1.31
**ผู้วิเคราะห์:** monthop-gmail

---

## ปัญหา

สระอา (า) และ สระอำ (ำ) ไม่แสดงบนหน้าจอใน Claude Code

| พิมพ์ | ควรได้ | ได้จริง |
|-------|--------|---------|
| สวัสดีจ้า | สวัสดีจ้า | สวัสดีจ้ |
| น้ำ | น้ำ | น้ |
| ภาษาไทย | ภาษาไทย | ภษไทย |

**หมายเหตุ:** ไฟล์บันทึกถูกต้อง ปัญหาเฉพาะการแสดงผลบนหน้าจอ

---

## Root Cause

### ตำแหน่ง Bug
ฟังก์ชัน `MD7()` ใน `cli.js` (minified) - ใช้คำนวณ character width

### Code ที่มีปัญหา
```javascript
// BUG: นับ 3633-3642 เป็น zero-width ทั้งหมด
if(A>=3633&&A<=3642||A>=3655&&A<=3662||...)return!0
```

### วิเคราะห์ Unicode Range

| Decimal | Unicode | ตัวอักษร | Category | Zero-width? |
|---------|---------|----------|----------|-------------|
| 3633 | U+0E31 | ◌ิ (Sara I) | Mn | ✅ ใช่ |
| **3634** | **U+0E32** | **า (Sara Aa)** | **Lo** | ❌ **ไม่ใช่!** |
| **3635** | **U+0E33** | **ำ (Sara Am)** | **Lo** | ❌ **ไม่ใช่!** |
| 3636 | U+0E34 | ◌ี (Sara Ii) | Mn | ✅ ใช่ |
| 3637 | U+0E35 | ◌ึ (Sara Ue) | Mn | ✅ ใช่ |
| 3638 | U+0E36 | ◌ื (Sara Uee) | Mn | ✅ ใช่ |
| 3639 | U+0E37 | ◌ุ (Maitaikhu) | Mn | ✅ ใช่ |
| 3640 | U+0E38 | ◌ู (Sara U) | Mn | ✅ ใช่ |
| 3641 | U+0E39 | ◌ฺ (Sara Uu) | Mn | ✅ ใช่ |
| 3642 | U+0E3A | ◌์ (Phinthu) | Mn | ✅ ใช่ |

**Mn** = Mark, Nonspacing (combining, zero-width)
**Lo** = Letter, other (spacing, width = 1)

### สาเหตุ
Code นับ สระอา (3634) และ สระอำ (3635) เป็น zero-width combining character
แต่จริงๆ ทั้งคู่เป็น **spacing vowel** ที่มี width = 1

---

## Proposed Fix

### แก้จาก:
```javascript
A>=3633&&A<=3642
```

### เป็น:
```javascript
A===3633||A>=3636&&A<=3642
```

(ข้าม 3634 และ 3635)

---

## GitHub Issue

### Main Issue
- **URL:** https://github.com/anthropics/claude-code/issues/21149
- **Title:** Claude Code v2.1.20: Thai text output drops vowels
- **Status:** Open
- **Labels:** `bug`, `has repro`, `area:tui`, `area:a11y`

### Comment ที่ Post
- **URL:** https://github.com/anthropics/claude-code/issues/21149#issuecomment-3846100665
- **เนื้อหา:** Technical Root Cause Analysis พร้อม proposed fix

### Related Issues
- #21787: Thai vowels not rendering correctly
- #22515: Thai character rendering disappears
- #22307: Thai vowel characters not rendering
- #22390: Thai vowel "า" not rendering
- #22499: Thai combining characters not displayed
- #22982: Thai combining vowels not rendering
- #21711: Thai Combining Characters Not Rendered
- #17860: Thai combining characters misaligned

---

## Platforms ที่ได้รับผลกระทบ

- ✅ Windows Terminal (WSL2)
- ✅ Android JuiceSSH
- ✅ Android Termux
- ✅ macOS Terminal
- ✅ iTerm2

(เกิดทุก platform เพราะ bug อยู่ใน Claude Code ไม่ใช่ terminal)

---

## ไฟล์ที่เตรียมไว้

```
claude-code-thai-vowel-fix/
├── BUG_REPORT.md           # รายงาน bug แบบละเอียด
├── FIX_DESCRIPTION.md      # คำอธิบาย fix สำหรับ developer
├── SUMMARY.md              # ไฟล์นี้ - สรุปทั้งหมด
├── thai-vowel-fix.sh       # 🆕 Script apply fix
└── thai-vowel-fix-revert.sh # 🆕 Script revert fix
```

## วิธีใช้ Patch Script

### Apply fix (ใช้หลัง claude update ทุกครั้ง)
```bash
./thai-vowel-fix.sh
```

### Revert กลับ (ถ้าต้องการทดสอบ)
```bash
./thai-vowel-fix-revert.sh
```

> **หมายเหตุ:** Script จะ backup ไฟล์เดิมโดยอัตโนมัติ

---

## สถานะ

- [x] วิเคราะห์ Root Cause
- [x] หา Proposed Fix
- [x] Comment ที่ GitHub Issue
- [ ] รอ Anthropic team fix
- [ ] ทดสอบ version ใหม่

---

## อ้างอิง

- Unicode Standard: https://unicode.org/charts/PDF/U0E00.pdf
- Claude Code Repo: https://github.com/anthropics/claude-code
- Issue #21149: https://github.com/anthropics/claude-code/issues/21149
