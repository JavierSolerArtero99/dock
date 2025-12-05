#!/bin/bash

cmd_start() {
    print_info "$MSG_INFO_LIFTING $(get_project_dir)"
    run_compose up -d --remove-orphans
    print_success "$MSG_SUCCESS_CONTAINERS_UP"
    echo ""
    run_compose exec -d app php artisan serve --host=0.0.0.0 --port=8000
    print_success "$MSG_SUCCESS_LARAVEL_STARTED"
    run_compose exec -d node npm run dev
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
