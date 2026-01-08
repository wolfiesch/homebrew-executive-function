# Homebrew Executive Function

Homebrew tap for the Executive Function tool suite - high-performance CLI tools for personal productivity.

## Installation

```bash
brew tap wolfiesch/executive-function
brew install wolfies-imessage
```

## Available Formulas

| Formula | Description | Platform |
|---------|-------------|----------|
| `wolfies-imessage` | iMessage CLI with daemon architecture (19x faster than MCP) | macOS only |
| `wolfies-gmail` | Gmail CLI | macOS, Linux |
| `wolfies-calendar` | Google Calendar CLI | macOS, Linux |
| `wolfies-reminders` | Apple Reminders CLI | macOS only |
| `executive-function` | Meta-formula: installs all tools | macOS |

## Quick Start

```bash
# Install iMessage tools
brew install wolfiesch/executive-function/wolfies-imessage

# Start the daemon
brew services start wolfies-imessage

# Use the CLI
wolfies-imessage health
wolfies-imessage unread --limit 5
wolfies-imessage recent --limit 10
```

## Architecture

Each tool uses a daemon architecture for performance:
- **Rust CLI**: Fast (~3ms spawn) command-line interface
- **Python Daemon**: Warm process handling API calls
- **Unix Socket**: Low-latency IPC between CLI and daemon

This approach achieves 19x faster response times compared to traditional MCP servers.

## Requirements

- macOS (for iMessage and Reminders)
- Python 3.11+
- Full Disk Access permission (for iMessage database access)

## Documentation

- [LIFE-PLANNER Repository](https://github.com/wolfiesch/LIFE-PLANNER)
- [Architecture Overview](https://github.com/wolfiesch/LIFE-PLANNER/blob/main/Plans/Rust_Gateway_Framework_2026-01-08.md)

## License

MIT
