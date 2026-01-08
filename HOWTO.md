# VIBECODING Logger - Quick Reference

## Daily Use (No Thinking Required)

### During Claude Session
Tell Claude:
```
"log this: [what we did]"
```
or just:
```
"we're done"
```
Claude will log and check for uncommitted work.

### End of Session
```bash
vcheck
```
If stuff shows up → paste to Claude → Claude commits it.

### That's it. Everything else is automatic.

---

## Commands Cheatsheet

| Command | What it does |
|---------|--------------|
| `log "message"` | Add note to today's log |
| `vcheck` | Show uncommitted work |
| `vcommit` | Quick commit everything (lazy mode) |
| `cat ~/ŻYCIE/VIBECODING/WORK_LOGS` | See today's log |

---

## What Happens Automatically

| When | What |
|------|------|
| You close Claude | Session gets logged (time + directory) |
| 11pm daily | Fresh WORK_LOGS created with all commits |
| Next day | Yesterday's log archived to `archive/` |

---

## Example WORK_LOGS

```
# WORK LOG - 2026-01-08

## Commits (3)

### settings-tools (2)
- [1ef842b] Update README
- [9319bee] Initial commit

## Progress

- **14:30** Built automated work logging system
- **15:00** Added commit checker
- **15:45** [session] worked in VIBECODING
```

---

## If Something Breaks

```bash
# Regenerate today's log
~/ŻYCIE/VIBECODING/generate-log.sh

# Check cron is running
crontab -l | grep VIBECODING
```

---

## Files Location

Everything is in: `~/ŻYCIE/VIBECODING/`

- `WORK_LOGS` - today's log
- `archive/` - old logs
- `*.sh` - scripts (don't touch)
