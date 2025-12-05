#!/bin/bash

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
