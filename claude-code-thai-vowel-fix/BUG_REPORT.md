# Bug Report: Thai Sara Aa (า) and Sara Am (ำ) not displayed

## Summary

Thai vowels สระอา (า) U+0E32 and สระอำ (ำ) U+0E33 are incorrectly treated as zero-width combining characters, causing them to not display on the terminal UI.

**Version:** Claude Code 2.1.31
**Severity:** Critical - affects all Thai language workflows

## Reproduction Steps

1. Open Claude Code
2. Type Thai text containing สระอา: `สวัสดีจ้า`
3. Observe that า is missing on screen

**Expected:** `สวัสดีจ้า`
**Actual:** `สวัสดีจ้` (สระอา missing)

## Affected Platforms

- Windows Terminal (WSL2)
- Android JuiceSSH
- Android Termux
- macOS Terminal

The bug occurs across all terminals because it's in Claude Code's rendering layer, not terminal-specific.

## Technical Analysis

### Root Cause

In the character width calculation function `MD7()` (minified name), the Thai character range check is incorrect:

```javascript
// Current (BUGGY):
if(A>=3633&&A<=3642||A>=3655&&A<=3662||...)return!0
```

This treats characters 3633-3642 as zero-width, but:

| Decimal | Unicode | Character | Actual Type |
|---------|---------|-----------|-------------|
| 3633 | U+0E31 | ◌ิ (Sara I) | Combining (zero-width) ✅ |
| **3634** | **U+0E32** | **า (Sara Aa)** | **Spacing vowel (width=1)** ❌ |
| **3635** | **U+0E33** | **ำ (Sara Am)** | **Spacing vowel (width=1)** ❌ |
| 3636 | U+0E34 | ◌ี (Sara Ii) | Combining (zero-width) ✅ |
| 3637 | U+0E35 | ◌ึ (Sara Ue) | Combining (zero-width) ✅ |
| 3638 | U+0E36 | ◌ื (Sara Uee) | Combining (zero-width) ✅ |
| 3639 | U+0E37 | ◌ุ (Sara U) | Combining (zero-width) ✅ |
| 3640 | U+0E38 | ◌ู (Sara Uu) | Combining (zero-width) ✅ |
| 3641 | U+0E39 | ◌ฺ (Phinthu) | Combining (zero-width) ✅ |
| 3642 | U+0E3A | ◌์ (Thanthakhat) | Combining (zero-width) ✅ |

### Unicode Reference

According to the Unicode Standard:
- **U+0E32 THAI CHARACTER SARA AA** - General Category: **Lo** (Letter, other) - **NOT a combining mark**
- **U+0E33 THAI CHARACTER SARA AM** - General Category: **Lo** (Letter, other) - **NOT a combining mark**

These are spacing characters with display width = 1, not combining marks.

### Proposed Fix

Change from:
```javascript
A>=3633&&A<=3642
```

To:
```javascript
A===3633||A>=3636&&A<=3642
```

This excludes U+0E32 (3634) and U+0E33 (3635) from the zero-width character check.

## Impact

- All Thai text containing สระอา or สระอำ displays incorrectly
- Affects millions of Thai words (า is one of the most common characters)
- Data is saved correctly to files, only terminal display is affected

## Related Issues

- #19365: Thai text with combining characters renders incorrectly
- #21149: Claude Code v2.1.20: Thai text output drops vowels

## Test Cases

After fix, these should display correctly:

| Input | Expected Display |
|-------|-----------------|
| สวัสดีจ้า | สวัสดีจ้า |
| ภาษาไทย | ภาษาไทย |
| ขอบคุณครับ | ขอบคุณครับ |
| น้ำ | น้ำ |
| ลำดับ | ลำดับ |
