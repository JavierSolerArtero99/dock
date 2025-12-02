#!/bin/bash

# Configuration commands
cmd_use() {
    if [ -z "$1" ]; then
        print_error "$MSG_ERR_SPECIFY_PATH"
        echo "$MSG_HELP_USE"
        exit 1
    fi
    set_project_dir "$1"
}

cmd_which() {
    local project_dir=$(get_project_dir)
    if [ -z "$project_dir" ]; then
        print_warning "$MSG_WARN_NO_PROJECT"
    else
        print_info "$MSG_INFO_PROJECT $project_dir"
    fi
}

cmd_init() {
    local project_dir=$(require_project)
    print_info "$MSG_INFO_INIT $project_dir"

    if [ ! -f "$DOCK_DIR/$DOCK_ENV" ]; then
        cp "$DOCK_DIR/templates/dock.env.template" "$DOCK_DIR/$DOCK_ENV"
        print_success "$MSG_SUCCESS_CREATED $DOCK_ENV"
    else
        print_warning "$DOCK_ENV $MSG_WARN_FILE_EXISTS"
    fi

    if [ -f "$project_dir/.env" ]; then
        print_info "$MSG_INFO_VERIFY_ENV"
        echo ""
        echo -e "${YELLOW}${MSG_ENV_CONFIG_HEADER} $project_dir/.env:${NC}"
        echo ""
        echo "$MSG_ENV_CONFIG_DB"
        echo ""
        echo "$MSG_ENV_CONFIG_MAIL"
        echo ""
    elif [ -f "$project_dir/.env.example" ]; then
        cp "$project_dir/.env.example" "$project_dir/.env"
        print_success "$MSG_SUCCESS_CREATED_ENV"
    fi

    print_success "$MSG_SUCCESS_INIT"
}

cmd_config() {
    if [ ! -f "$DOCK_DIR/$DOCK_ENV" ]; then
        print_warning "$MSG_WARN_NO_ENV"
        exit 1
    fi
    ${EDITOR:-nano} "$DOCK_DIR/$DOCK_ENV"
}

# Container commands
cmd_start() {
    print_info "$MSG_INFO_LIFTING $(get_project_dir)"
    run_compose up -d --remove-orphans
    print_success "$MSG_SUCCESS_CONTAINERS_UP"
    echo ""
    run_compose exec -d app php artisan serve --host=0.0.0.0 --port=8000
    print_success "$MSG_SUCCESS_LARAVEL_STARTED"
    run_compose exec -d node npm run dev -- --host
    print_success "$MSG_SUCCESS_VITE_STARTED"
    echo ""
    print_services
}

cmd_stop() {
    print_info "$MSG_INFO_STOPPING"
    run_compose down
    print_success "$MSG_SUCCESS_CONTAINERS_DOWN"
}

cmd_restart() {
    print_info "$MSG_INFO_RESTARTING"
    run_compose restart
    print_success "$MSG_SUCCESS_CONTAINERS_RESTART"
}

cmd_destroy() {
    print_warning "$MSG_WARN_DESTROY"
    echo "$MSG_WARN_DESTROY_CONTAINERS"
    echo "$MSG_WARN_DESTROY_VOLUMES"
    echo "$MSG_WARN_DESTROY_IMAGES"
    echo ""
    read -p "$MSG_PROMPT_CONFIRM" confirm
    if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
        print_info "$MSG_INFO_DELETING"
        run_compose down -v --rmi local --remove-orphans
        print_success "$MSG_SUCCESS_DELETED"
    else
        print_info "$MSG_INFO_CANCELLED"
    fi
}

cmd_status() {
    print_header
    print_info "$MSG_INFO_PROJECT $(get_project_dir)"
    echo ""
    run_compose ps
}

cmd_logs() {
    if [ -z "$1" ]; then
        run_compose logs -f
    else
        run_compose logs -f "$1"
    fi
}

# Access commands
cmd_shell() {
    run_compose exec app bash
}

cmd_root() {
    run_compose exec -u root app bash
}

cmd_mysql() {
    load_env
    run_compose exec db mysql -u"${DB_USERNAME:-laravel}" -p"${DB_PASSWORD:-secret}" "${DB_DATABASE:-laravel}"
}

# Laravel commands
cmd_artisan() {
    run_compose exec app php artisan "$@"
}

cmd_composer() {
    run_compose exec app composer "$@"
}

cmd_tinker() {
    run_compose exec app php artisan tinker
}

cmd_test() {
    run_compose exec app php artisan test "$@"
}

cmd_migrate() {
    print_info "$MSG_INFO_RUNNING_MIGRATIONS"
    run_compose exec app php artisan migrate
    print_success "$MSG_SUCCESS_MIGRATIONS"
}

cmd_fresh() {
    print_info "$MSG_INFO_RUNNING_FRESH"
    run_compose exec app php artisan migrate:fresh --seed
    print_success "$MSG_SUCCESS_FRESH"
}

# Node commands
cmd_npm() {
    run_compose exec node npm "$@"
}

cmd_npx() {
    run_compose exec node npx "$@"
}

cmd_yarn() {
    run_compose exec node yarn "$@"
}

cmd_dev() {
    print_info "$MSG_INFO_VITE_DEV"
    run_compose exec node npm run dev -- --host
}

cmd_build_assets() {
    print_info "$MSG_INFO_VITE_BUILD"
    run_compose exec node npm run build
    print_success "$MSG_SUCCESS_VITE_BUILD"
}

# Setup commands
cmd_build() {
    print_info "$MSG_INFO_REBUILDING"
    run_compose build --no-cache
    print_success "$MSG_SUCCESS_BUILD"
}

cmd_install() {
    local project_dir=$(require_project)
    print_header
    print_info "$MSG_INFO_INSTALLING $project_dir"

    if [ ! -f "$DOCK_DIR/$DOCK_ENV" ]; then
        cmd_init
    fi

    print_info "$MSG_INFO_BUILDING"
    run_compose build

    print_info "$MSG_INFO_LIFTING"
    run_compose up -d

    print_info "$MSG_INFO_WAITING_MYSQL"
    sleep 10

    print_info "$MSG_INFO_INSTALLING_DEPS"
    run_compose exec app composer install

    print_info "$MSG_INFO_INSTALLING_NODE_DEPS"
    run_compose exec node npm install

    if [ -f "$project_dir/.env" ]; then
        if grep -q "APP_KEY=$" "$project_dir/.env" || grep -q 'APP_KEY=""' "$project_dir/.env"; then
            print_info "$MSG_INFO_GENERATING_KEY"
            run_compose exec app php artisan key:generate
        fi
    fi

    print_info "$MSG_INFO_RUNNING_MIGRATIONS"
    run_compose exec app php artisan migrate --force || true

    print_success "$MSG_SUCCESS_INSTALL"
    echo ""
    print_services
}
