# Fix: Thai Sara Aa (า) and Sara Am (ำ) Display Bug

## The Problem

In the `isZeroWidthCharacter()` function (minified as `MD7`), Thai characters U+0E32 (สระอา) and U+0E33 (สระอำ) are incorrectly identified as zero-width combining characters.

## Location in Source

The bug is in the character width calculation logic, likely in a file related to terminal rendering or string width calculation.

Look for code similar to:

```javascript
// Check if character is zero-width/combining
function isZeroWidthCharacter(codePoint) {
  // ... other checks ...

  // Thai combining marks - THIS IS THE BUG
  if (codePoint >= 0x0E31 && codePoint <= 0x0E3A) return true;
  // or in decimal:
  if (codePoint >= 3633 && codePoint <= 3642) return true;

  // ... more checks ...
}
```

## The Fix

### Option 1: Exclude specific characters
```javascript
// Before (BUGGY):
if (codePoint >= 0x0E31 && codePoint <= 0x0E3A) return true;

// After (FIXED):
if (codePoint === 0x0E31 || (codePoint >= 0x0E34 && codePoint <= 0x0E3A)) return true;
```

### Option 2: Explicit list
```javascript
// Thai combining marks (excluding spacing vowels)
const thaiCombining = [
  0x0E31,         // Sara I
  // 0x0E32,      // Sara Aa - SPACING, NOT combining
  // 0x0E33,      // Sara Am - SPACING, NOT combining
  0x0E34,         // Sara Ii
  0x0E35,         // Sara Ue
  0x0E36,         // Sara Uee
  0x0E37,         // Maitaikhu
  0x0E38,         // Sara U
  0x0E39,         // Sara Uu
  0x0E3A,         // Phinthu
];

if (thaiCombining.includes(codePoint)) return true;
```

### Option 3: Check Unicode General Category
```javascript
// More robust: check if character is actually a combining mark
// Unicode General_Category = Mn (Mark, Nonspacing)
// U+0E32 and U+0E33 have category Lo (Letter, other)
```

## Minified Code Patch

In `cli.js`, find and replace:

```
// Find:
A>=3633&&A<=3642

// Replace with:
A===3633||A>=3636&&A<=3642
```

## Verification

After applying the fix, test with:

```bash
echo "Testing Thai: สวัสดีจ้า ภาษาไทย น้ำ ลำดับ"
```

All characters should display correctly.

## Unicode Reference

| Code | Hex | Char | Name | Category | Zero-width? |
|------|-----|------|------|----------|-------------|
| 3633 | 0E31 | ◌ิ | SARA I | Mn | Yes |
| 3634 | 0E32 | า | SARA AA | **Lo** | **No** |
| 3635 | 0E33 | ำ | SARA AM | **Lo** | **No** |
| 3636 | 0E34 | ◌ี | SARA II | Mn | Yes |
| 3637 | 0E35 | ◌ึ | SARA UE | Mn | Yes |
| 3638 | 0E36 | ◌ื | SARA UEE | Mn | Yes |
| 3639 | 0E37 | ◌ุ | MAITAIKHU | Mn | Yes |
| 3640 | 0E38 | ◌ู | SARA U | Mn | Yes |
| 3641 | 0E39 | ◌ฺ | SARA UU | Mn | Yes |
| 3642 | 0E3A | ◌์ | PHINTHU | Mn | Yes |

**Mn** = Mark, Nonspacing (combining, zero-width)
**Lo** = Letter, other (spacing, width = 1)
