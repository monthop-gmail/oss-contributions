# OpenCode LINE Integration

LINE Messaging API integration for OpenCode AI coding agent.

## Links

| Item | URL |
|------|-----|
| Issue | https://github.com/anomalyco/opencode/issues/13801 |
| PR | https://github.com/anomalyco/opencode/pull/13799 |
| Standalone repo | https://github.com/monthop-gmail/opencode-line |
| OpenCode | https://github.com/anomalyco/opencode |

## Two Versions

### 1. Monorepo version (PR #13799)

อยู่ใน `packages/line/` ของ opencode monorepo ใช้ `@opencode-ai/sdk` (`createOpencode`) ตาม pattern เดียวกับ `packages/slack/`

- ใช้ SDK: `createOpencode({ port: 0 })`, `client.session.create()`, `client.session.prompt()`
- Subscribe tool update events แบบ real-time
- รัน: `cd packages/line && bun dev`

### 2. Standalone version (opencode-line repo)

Deploy แยกด้วย Docker Compose โดยไม่ต้อง clone monorepo

- ใช้ `fetch()` ตรงไป OpenCode REST API
- Docker Compose: 3 services (opencode, line-bot, cloudflared tunnel)
- รัน: `docker compose up -d`

## Architecture

```
User (LINE app)
  ↕  LINE Messaging API webhook
LINE Bot (Bun HTTP server)
  ↕  @opencode-ai/sdk or fetch()
OpenCode Server
  ↕
Project Filesystem
```

## Commands

- Send any text message → coding prompt
- `/new` - Start a new coding session
- `/abort` - Cancel the current prompt
- `/sessions` - Show active session info

## Key Technical Details

- LINE webhook signature validation (HMAC-SHA256)
- Message chunking for LINE's 5000 char limit (respects code blocks)
- Session mapping: LINE userId → OpenCode sessionId
- Real-time tool update notifications (file edits, bash commands)
