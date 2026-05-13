# TRMNL Trello Plugin Setup

Display cards from your Trello board ("Today" and "In Progress" lists) on your TRMNL e-ink display.

## Overview

- **Lists displayed**: 📨 Today (top 6 cards), 👨‍💻 In Progress (top 4 cards)
- **Update frequency**: Every 15 minutes during work hours (9am-6pm, Monday-Friday)
- **Layout**: Half-screen vertical (pairs well with another plugin)
- **Data shown**: Card title + label emoji
- **Deduplication**: Duplicate cards (same title) are automatically removed

## Architecture

```
┌─────────────────┐      ┌──────────────────┐      ┌─────────────┐
│  Trello API     │ ───> │  Sync Script     │ ───> │   TRMNL     │
│  (Board)        │      │  (Node.js)       │      │   Webhook   │
└─────────────────┘      └──────────────────┘      └─────────────┘
                                 │
                                 │ Runs every 15 min (9am-6pm)
                                 ▼
                         ┌──────────────────┐
                         │  LaunchAgent     │
                         │  (macOS)         │
                         └──────────────────┘
```

## Prerequisites

- TRMNL device configured
- Trello API key and token (from https://trello.com/app-key)
- Trello board ID and list IDs

## Setup Instructions

### 1. Create TRMNL Private Plugin

1. Go to https://trmnl.com/plugin_settings/new?keyname=private_plugin
2. Name it "Trello Board"
3. Click "Save" to generate your plugin UUID
4. Copy the **Webhook URL** (format: `https://trmnl.com/api/custom_plugins/YOUR_UUID`)
5. Keep this page open - you'll paste the markup template in step 4

### 2. Configure Environment Variables

Add these to your `~/.env.sh.local`:

```bash
# Trello API credentials (already configured)
export TRELLO_API_KEY="your_api_key"
export TRELLO_TOKEN="your_token"
export TRELLO_BOARD_ID="69a5e3955d95844019dd15e1"
export TRELLO_TODAY_LIST_ID="69a5e3955d95844019dd1603"
export TRELLO_INPROGRESS_LIST_ID="69a5ebf4eaaa556ced27f52f"

# TRMNL webhook URL (from step 1)
export TRMNL_WEBHOOK_URL="https://trmnl.com/api/custom_plugins/YOUR_UUID"
```

Reload your environment:

```bash
source ~/.env.sh.local
```

### 3. Test the Sync Script

Run the sync script manually to verify it works:

```bash
~/.local/bin/trmnl-trello-sync
```

Expected output:

```
==> TRMNL Trello Sync
--> Started at 2026-05-06T14:30:00Z
--> Environment validated
--> Fetching cards from Trello...
--> Found 14 Today cards, 4 In Progress cards
--> Posting to TRMNL webhook...
==> Success! TRMNL updated.
```

### 4. Create Markup Templates in TRMNL

TRMNL requires markup for all layout sizes. Open `docs/trmnl-trello-markup-all-layouts.html` which contains all four templates.

1. Go back to your TRMNL plugin settings page
2. Click the "Markup Editor" tab
3. Copy each section from `trmnl-trello-markup-all-layouts.html` into the corresponding field:
   - **Full Screen** → `markup` field
   - **Half Vertical** → `markup_half_vertical` field
   - **Half Horizontal** → `markup_half_horizontal` field
   - **Quadrant** → `markup_quadrant` field

4. Click "Preview" on each to verify they render correctly
5. Click "Save"

**Note:** Each layout shows a different number of cards optimized for screen space:
- Full: All cards (6 Today + 4 In Progress) in two columns
- Half Vertical: All cards (6 Today + 4 In Progress) stacked
- Half Horizontal: Limited cards (4 Today + 3 In Progress) side-by-side
- Quadrant: Minimal cards (3 Today + 2 In Progress) for small space

### 5. Install LaunchAgent

The LaunchAgent will run the sync script every 15 minutes automatically.

```bash
# Copy plist to LaunchAgents directory (already stowed)
# Verify it's in place:
ls -l ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist

# Load the LaunchAgent
launchctl load ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist

# Verify it's loaded
launchctl list | grep trmnl-trello
```

### 6. Verify It's Working

Check the logs after a few minutes:

```bash
tail -f ~/.local/state/trmnl-trello-sync.log
```

You should see log entries every 15 minutes (during work hours only).

## Usage

### Manual Sync

Force a sync anytime:

```bash
~/.local/bin/trmnl-trello-sync
```

Or trigger via LaunchAgent:

```bash
launchctl start piet.trmnl-trello-sync
```

### View Logs

```bash
# Tail logs in real-time
tail -f ~/.local/state/trmnl-trello-sync.log

# View recent errors
grep "Error" ~/.local/state/trmnl-trello-sync.log

# Check last 10 runs
tail -20 ~/.local/state/trmnl-trello-sync.log
```

### Restart LaunchAgent

If you update the script or plist:

```bash
launchctl unload ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist
launchctl load ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist
```

### Disable LaunchAgent

To stop automatic syncing:

```bash
launchctl unload ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist
```

## Troubleshooting

### Script fails with "Missing required environment variables"

Make sure `~/.env.sh.local` contains all required variables and is being sourced correctly.

Test manually:

```bash
source ~/.env.sh.local
echo $TRMNL_WEBHOOK_URL
```

### "Trello authentication failed"

Verify your `TRELLO_API_KEY` and `TRELLO_TOKEN` are correct:

```bash
# Test Trello API directly
node -e "fetch('https://api.trello.com/1/boards/69a5e3955d95844019dd15e1?key=$TRELLO_API_KEY&token=$TRELLO_TOKEN').then(r => r.json()).then(console.log)"
```

### "TRMNL API error: 404"

Your webhook URL is incorrect. Get the correct URL from your TRMNL plugin settings page.

### "Rate limited"

TRMNL allows 12 updates/hour (or 30 with TRMNL+). The script runs every 15 minutes = 4/hour, well within limits. If you see rate limiting, check for duplicate LaunchAgents:

```bash
launchctl list | grep trmnl
```

### No updates appearing on TRMNL

1. Check the script is running: `launchctl list | grep trmnl-trello`
2. Check logs: `tail ~/.local/state/trmnl-trello-sync.log`
3. Verify TRMNL device is online and configured
4. Test webhook manually:

```bash
curl -X POST "https://trmnl.com/api/custom_plugins/YOUR_UUID" \
  -H "Content-Type: application/json" \
  -d '{"merge_variables": {"today": [{"title": "Test card", "emoji": "💁‍♂️"}], "in_progress": [], "updated_at": "2026-05-06T14:30:00Z"}}'
```

### Script only runs some hours

This is by design! The wrapper script checks if it's work hours (9am-6pm, Monday-Friday) and exits silently outside those hours. This saves API quota and battery.

## Customization

### Change Update Frequency

Edit `macos/Library/LaunchAgents/piet.trmnl-trello-sync.plist` and change the `StartInterval`:

```xml
<key>StartInterval</key>
<integer>1800</integer>  <!-- 30 minutes = 1800 seconds -->
```

Then reload:

```bash
launchctl unload ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist
launchctl load ~/Library/LaunchAgents/piet.trmnl-trello-sync.plist
```

### Change Work Hours

Edit `shell/.local/bin/trmnl-trello-sync-runner` and adjust:

```bash
# Change to 8am-7pm:
if [ "$current_day" -gt 5 ] || [ "$current_hour" -lt 8 ] || [ "$current_hour" -ge 19 ]; then
```

### Change Card Limits

Edit `shell/.local/bin/trmnl-trello-sync` and adjust:

```javascript
const MAX_TODAY_CARDS = 6;        // Change to 8
const MAX_INPROGRESS_CARDS = 4;   // Change to 3
```

### Add More Lists

1. Get the list ID from Trello
2. Add to environment variables
3. Update the sync script to fetch that list
4. Update the markup template to display it

## Files

- `shell/.local/bin/trmnl-trello-sync` - Main Node.js sync script
- `shell/.local/bin/trmnl-trello-sync-runner` - Bash wrapper (loads env vars, checks work hours)
- `macos/Library/LaunchAgents/piet.trmnl-trello-sync.plist` - macOS LaunchAgent config
- `~/.env.sh.local` - Private config file (not in repo, contains webhook URL)
- `~/.local/state/trmnl-trello-sync.log` - Log file

## Security Note

- **Never commit** your `TRMNL_WEBHOOK_URL` or Trello credentials to the public repo
- Keep them in `~/.env.sh.local` (git-ignored)
- The scripts and plist are safe to commit (no secrets)
