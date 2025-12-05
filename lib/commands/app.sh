#!/bin/bash

cmd_shell() {
    run_compose exec app bash
}

cmd_root() {
    run_compose exec -u root app bash
}

cmd_artisan() {
    run_compose exec app php artisan "$@"
}

cmd_composer() {
    run_compose exec app composer "$@"
}
