# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Laravel Docker CLI (`dock`) - A reusable bash CLI for dockerizing any Laravel project. The tool manages Docker containers, runs Laravel/Node commands, and handles project configuration through a central location.

## Architecture

```
dock (main entry point)
├── lib/constants.sh       # Colors, config vars, all UI messages (Spanish)
├── lib/utils.sh           # Helper functions: print_*, project dir, env loading, docker compose wrapper
├── lib/commands/
│   ├── config.sh          # init, config
│   ├── docker.sh          # start, stop, restart, destroy, status, logs, build, install
│   ├── app.sh             # shell, root, artisan, composer
│   ├── node.sh            # npm, npx, yarn, dev, build_assets
│   └── db.sh              # mysql
├── docker/php/            # PHP 8.4-cli Dockerfile with Laravel extensions
└── templates/             # dock.env.template, help.txt
```

**Key patterns:**
- Commands are implemented as `cmd_<name>()` functions in `lib/commands/<container>.sh`
- `run_compose()` wraps all docker compose calls, auto-loading env and setting PROJECT_PATH
- Project path stored in `.dock` file, env config in `.dock.env`
- All user-facing messages are constants in `lib/constants.sh` (Spanish)

## Docker Services

- **app**: PHP 8.4-cli container (port 8000) - runs `artisan serve`
- **node**: Node 20-alpine (port 5173) - Vite dev server
- **db**: MySQL 8.0 (port 3306) with healthcheck
- **mailpit**: SMTP testing (1025/8025)

## Common Commands

Run all commands from within a Laravel project directory (auto-detected via `artisan` file).

```bash
# Initialize and install
dock init       # Create .dock.env config
dock install    # Full installation (build, deps, migrations)

# Start/stop containers
./dock start    # Brings up containers + starts artisan serve + vite
./dock stop
./dock destroy  # Removes everything including volumes

# Laravel commands
./dock artisan <command>   # e.g. artisan migrate, artisan tinker, artisan test
./dock composer <command>

# Node commands
./dock npm <command>
./dock dev      # Vite dev server
./dock build-assets

# Access
./dock shell    # bash in app container
./dock mysql    # MySQL CLI
```

## Adding New Commands

1. Add `cmd_<name>()` function to the appropriate file in `lib/commands/`
2. Add case to router in `dock` main file
3. Add any new messages to `lib/constants.sh`
