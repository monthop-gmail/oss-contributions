# Claude Code LINE Integration

LINE Messaging API bridge for Claude Code CLI.

## Links

| Item | URL |
|------|-----|
| Repo | https://github.com/monthop-gmail/claude-code-line |
| Claude Code | https://github.com/anthropics/claude-code |

## Architecture

```
User (LINE app)
  ↕  LINE Messaging API webhook
claude-code-line (Bun HTTP server)
  ↕  spawn("claude", ["-p", prompt, "--resume", sessionId])
Claude Code CLI
  ↕
Project Filesystem (/workspace)
```

## How it differs from opencode-line

| | opencode-line | claude-code-line |
|---|---|---|
| AI Agent | OpenCode | Claude Code |
| Communication | `fetch()` → REST API | `Bun.spawn()` → CLI subprocess |
| Docker services | 3 (server, bot, tunnel) | 2 (bot+CLI, tunnel) |
| Session resume | REST API session ID | `--resume <session_id>` flag |
| Auth | Basic auth (OPENCODE_PASSWORD) | ANTHROPIC_API_KEY |

## Key Technical Details

- Docker: `node:22-slim` + bun + `@anthropic-ai/claude-code` globally installed
- Non-root user required (`--dangerously-skip-permissions` refuses root)
- Per-user request queue (serialize subprocess calls per LINE user)
- Session persistence via `~/.claude` named volume
- `delete env.CLAUDECODE` before spawn to prevent nesting check
- Session expired auto-retry (if `--resume` fails, start fresh session)
- Cost tracking from `total_cost_usd` in JSON output

## Commands

- Send any text message → coding prompt
- `/new` - Start a new coding session
- `/abort` - Cancel the current prompt (kills subprocess)
- `/sessions` - Show active session info + cost
- `/cost` - Show total cost for current session

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ANTHROPIC_API_KEY` | - | Anthropic API key (required) |
| `CLAUDE_MODEL` | `sonnet` | Claude model |
| `CLAUDE_MAX_TURNS` | `10` | Max agentic turns per prompt |
| `CLAUDE_MAX_BUDGET_USD` | `1.00` | Max spend per prompt |
| `CLAUDE_TIMEOUT_MS` | `300000` | Timeout per prompt (5 min) |
