#!/bin/bash

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
