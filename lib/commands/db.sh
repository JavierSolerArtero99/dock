#!/bin/bash

cmd_mysql() {
    load_env
    run_compose exec db mysql -u"${DB_USERNAME:-laravel}" -p"${DB_PASSWORD:-secret}" "${DB_DATABASE:-laravel}"
}
