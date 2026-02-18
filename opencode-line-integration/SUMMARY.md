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
OpenCode Server (big-pickle model, free)
  ↕
Project Filesystem
```

## Commands

- Send any text message → coding prompt
- `/new` - Start a new coding session
- `/abort` - Cancel the current prompt
- `/sessions` - Show active session info
- `/help` - Show all available commands
- `/about` - Bot introduction and info
- `/cny` - CNY greetings

## Features

### Core
- LINE webhook signature validation (HMAC-SHA256)
- Message chunking for LINE's 5000 char limit (respects code blocks)
- Session mapping: LINE userId → OpenCode sessionId
- Big-pickle free model (200K context, $0 cost)

### Group Chat Support
- Bot join/leave event handling with welcome message
- Session key uses groupId (shared session for all group members)
- 1:1 chat uses userId (private session per user)
- AI-powered message filtering: AI decides if message is directed at it, responds `[SKIP]` for unrelated group conversations
- No manual trigger needed (@bot, prefix) - natural group chat experience

### Image Message Support
- Download images via MessagingApiBlobClient (LINE SDK v9)
- Forward to OpenCode session with acknowledgment

### Robustness
- Prompt prefix prevents interactive question tool blocking
- 2-min timeout with partial response polling fallback
- Response extraction from all part types (text, reasoning, tool/question)
- Uses replyMessage (free, no quota) before falling back to pushMessage
- Retry with backoff (5s, 10s) on LINE 429 rate limit
- LINE free plan: 300 push messages/month, replyMessage unlimited

## Key Technical Details

- LINE Bot SDK v9: uses `MessagingApiBlobClient` for binary content (image download)
- OpenCode question tool fix: prompt prefix instructs AI to respond directly without using interactive question tool, which blocks the REST API indefinitely
- Timeout handling: `AbortController` with 120s timeout, on timeout aborts session and fetches partial response via `GET /session/{id}/message`
- `extractResponse()`: handles text, reasoning, and tool/question part types as fallback

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LINE_CHANNEL_ACCESS_TOKEN` | - | LINE Messaging API token |
| `LINE_CHANNEL_SECRET` | - | LINE channel secret |
| `LINE_OA_URL` | - | LINE Official Account URL |
| `OPENCODE_URL` | `http://opencode:4096` | OpenCode server URL |
| `OPENCODE_PASSWORD` | `changeme` | OpenCode server password |
| `OPENCODE_DIR` | `/workspace` | Working directory |
| `PROMPT_TIMEOUT_MS` | `120000` | Prompt timeout (2 min) |
