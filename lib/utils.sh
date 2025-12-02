#!/bin/bash

# Print functions
print_header() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║       Laravel Docker CLI v1.0         ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info() { echo -e "${BLUE}→ $1${NC}"; }

# Project directory functions
get_project_dir() {
    if [ -n "$DOCK_PROJECT" ]; then
        echo "$DOCK_PROJECT"
    elif [ -f "$DOCK_DIR/$DOCK_CONFIG" ]; then
        cat "$DOCK_DIR/$DOCK_CONFIG"
    else
        echo ""
    fi
}

set_project_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        print_error "$MSG_ERR_DIR_NOT_EXISTS $dir"
        exit 1
    fi
    if [ ! -f "$dir/artisan" ]; then
        print_warning "$MSG_WARN_NOT_LARAVEL"
        read -p "$MSG_PROMPT_CONTINUE" confirm
        [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && exit 1
    fi
    echo "$(cd "$dir" && pwd)" > "$DOCK_DIR/$DOCK_CONFIG"
    print_success "$MSG_SUCCESS_PROJECT_SET $(cat "$DOCK_DIR/$DOCK_CONFIG")"
}

require_project() {
    local project_dir=$(get_project_dir)
    if [ -z "$project_dir" ]; then
        print_error "$MSG_ERR_NO_PROJECT"
        echo "$MSG_HELP_USE"
        exit 1
    fi
    if [ ! -d "$project_dir" ]; then
        print_error "$MSG_ERR_PROJECT_NOT_EXISTS $project_dir"
        exit 1
    fi
    echo "$project_dir"
}

# Environment functions
load_env() {
    if [ -f "$DOCK_DIR/$DOCK_ENV" ]; then
        export $(cat "$DOCK_DIR/$DOCK_ENV" | grep -v '^#' | xargs)
    fi
}

# Docker compose wrapper
run_compose() {
    local project_dir=$(require_project)
    load_env

    export PROJECT_PATH="$project_dir"
    export APP_NAME="${APP_NAME:-laravel}"
    export APP_PORT="${APP_PORT:-8000}"
    export DB_PORT="${DB_PORT:-3306}"
    export DB_DATABASE="${DB_DATABASE:-laravel}"
    export DB_USERNAME="${DB_USERNAME:-laravel}"
    export DB_PASSWORD="${DB_PASSWORD:-secret}"
    export MAIL_PORT="${MAIL_PORT:-1025}"
    export MAILPIT_UI_PORT="${MAILPIT_UI_PORT:-8025}"
    export VITE_PORT="${VITE_PORT:-5173}"

    $DOCKER_COMPOSE -f "$DOCK_DIR/docker-compose.yml" "$@"
}

# Print services info
print_services() {
    load_env
    echo -e "${GREEN}${MSG_SERVICES_HEADER}${NC}"
    echo "${MSG_SERVICES_APP}${APP_PORT:-8000}"
    echo "${MSG_SERVICES_VITE}${VITE_PORT:-5173}"
    echo "${MSG_SERVICES_MAILPIT}${MAILPIT_UI_PORT:-8025}"
}

# Show help
show_help() {
    print_header
    cat "$DOCK_DIR/templates/help.txt"
    echo ""
}
