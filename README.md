# Vibecoding Logger

A dead-simple work logging system for tracking daily coding progress with Claude Code.

**Stop losing track of what you built.** This logger automatically tracks your commits, lets you add progress notes, and ensures nothing goes uncommitted.

---

## Features

### Automatic Session Logging
Every time you close Claude Code, a session entry is automatically added to your log. Never forget that you worked on something.

### Single Daily Log File
One `WORK_LOGS` file shows everything you did today. Yesterday's log gets archived automatically at midnight. No clutter, no hunting through folders.

### Commit Tracking
All your git commits across projects are collected into your daily log. See exactly what you shipped.

### Quick Progress Notes
Add context to your work with one command:
```bash
log "Built the authentication system"
log "Fixed that annoying CSS bug"
```

### Uncommitted Work Checker
Before ending your day, see what you forgot to commit:
```bash
vcheck
```
Output:
```
my-project - 3 uncommitted changes:
  Modified: 2 files
    src/auth.js
    src/utils.js
  Untracked: 1 files
    src/new-feature.js
```

### Batch Commit (Lazy Mode)
Don't feel like writing commit messages? Commit everything at once:
```bash
vcommit
```

---

## Installation

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/vibecoding-logbook.git ~/ŻYCIE/VIBECODING

# Make scripts executable
chmod +x ~/ŻYCIE/VIBECODING/*.sh

# Add commands to your shell
echo '
# Vibecoding tools
log() { ~/ŻYCIE/VIBECODING/log.sh "$@"; }
vcheck() { ~/ŻYCIE/VIBECODING/check.sh; }
vcommit() { ~/ŻYCIE/VIBECODING/commit-all.sh; }
' >> ~/.bashrc

source ~/.bashrc

# Set up daily cron (generates fresh log at 11pm)
(crontab -l 2>/dev/null; echo "0 23 * * * ~/ŻYCIE/VIBECODING/generate-log.sh") | crontab -
```

### Claude Code Auto-Logging (Optional)

Add this to `~/.claude/settings.local.json`:
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": {},
        "hooks": [
          {
            "type": "command",
            "command": "~/ŻYCIE/VIBECODING/session-logger.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

---

## Usage

### Daily Workflow

```
┌─────────────────────────────────────────────────────────┐
│  START SESSION                                          │
│  Just start working with Claude                         │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  DURING SESSION                                         │
│  Tell Claude: "log this: built user authentication"     │
│  Or run: log "built user authentication"                │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  END SESSION                                            │
│  Run: vcheck                                            │
│  If uncommitted work → paste to Claude → Claude commits │
│  Or run: vcommit (lazy mode)                            │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  CLOSE CLAUDE                                           │
│  Session auto-logged (time + directory)                 │
└─────────────────────────────────────────────────────────┘
```

### Commands

| Command | Description |
|---------|-------------|
| `log "message"` | Add timestamped progress note |
| `vcheck` | Show all uncommitted work across projects |
| `vcommit` | Quick commit everything with "WIP" message |

### View Your Log

```bash
cat ~/ŻYCIE/VIBECODING/WORK_LOGS
```

---

## Example WORK_LOGS

```markdown
# WORK LOG - 2026-01-08

## Commits (5)

### my-webapp (3)
- [a1b2c3d] Add user authentication
- [e4f5g6h] Fix login redirect bug
- [i7j8k9l] Add session management

### cli-tool (2)
- [m1n2o3p] Initial commit
- [q4r5s6t] Add help command

## Progress

- **09:30** Started working on auth system
- **11:45** Fixed annoying redirect bug that took forever
- **14:00** Built CLI tool for internal use
- **16:30** [session] worked in my-webapp
- **17:15** [session] worked in cli-tool
```

---

## File Structure

```
vibecoding-logbook/
├── WORK_LOGS              # Today's log (auto-generated)
├── archive/               # Previous days (YYYY-MM-DD.md)
│
├── generate-log.sh        # Creates daily log, archives old
├── log.sh                 # Add progress notes
├── check.sh               # Find uncommitted work
├── commit-all.sh          # Batch commit everything
├── session-logger.sh      # Auto-log on Claude close
├── backfill.sh            # Generate logs for past days
│
├── README.md              # This file
└── HOWTO.md               # Quick reference card
```

---

## Configuration

Edit `generate-log.sh` to customize:

```bash
VIBECODING_DIR="~/your/projects/path"  # Where your projects live
GIT_EMAIL="you@email.com"              # Filter commits by author
```

---

## How It Works

### Daily Log Generation (`generate-log.sh`)
- Runs via cron at 11pm (or manually)
- Archives current WORK_LOGS to `archive/YYYY-MM-DD.md`
- Scans all git repos in your projects directory
- Collects today's commits by your email
- Creates fresh WORK_LOGS with commits section

### Progress Logging (`log.sh`)
- Appends timestamped message to WORK_LOGS
- Format: `- **HH:MM** your message`

### Session Auto-Logging (`session-logger.sh`)
- Triggered by Claude Code Stop hook
- Appends: `- **HH:MM** [session] worked in directory-name`
- Backup logging - always know a session happened

### Uncommitted Checker (`check.sh`)
- Scans all repos in projects directory
- Shows staged, modified, and untracked files
- Color-coded output (red = needs attention)

### Batch Commit (`commit-all.sh`)
- Commits all changes in all repos
- Uses message: "WIP: YYYY-MM-DD HH:MM session work"
- For when you just want to save everything quick

---

## FAQ

**Q: What if I forget to log?**
A: Session auto-logging catches it. You'll at least see `[session] worked in X`.

**Q: What if I forget to commit?**
A: Run `vcheck` - it shows everything uncommitted. Make it a habit before closing.

**Q: Can I edit the logs?**
A: Yes! `WORK_LOGS` is just a markdown file. Edit it anytime.

**Q: What about multiple machines?**
A: Each machine has its own WORK_LOGS. Sync the `archive/` folder if you want history everywhere.

---

## License

MIT

---

## Author

Built with Claude Code for tracking work done with Claude Code. Meta? Yes. Useful? Absolutely.
