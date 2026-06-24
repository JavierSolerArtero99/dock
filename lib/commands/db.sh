#!/bin/bash

cmd_mysql() {
    load_env
    run_compose exec db mysql -u"${DB_USERNAME:-laravel}" -p"${DB_PASSWORD:-secret}" "${DB_DATABASE:-laravel}"
}

# Importa la conexión a la base de datos local en Sequel Ace (macOS).
# En otros sistemas solo muestra los datos de conexión.
cmd_db_connections() {
    require_project >/dev/null
    load_env

    # La BD se expone en el host vía el puerto mapeado en docker-compose.yml
    local db_host="127.0.0.1"
    local db_port="${DB_PORT:-3306}"
    local db_name="${DB_DATABASE:-laravel}"
    local db_user="${DB_USERNAME:-laravel}"
    local db_pass="${DB_PASSWORD:-secret}"
    local project_name="$(basename "$(pwd)")"

    # En sistemas que no son macOS no existe Sequel Ace: mostramos la info.
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo ""
        echo "═══════════════════════════════════════════════════════════════"
        echo "  Datos de conexión MySQL"
        echo "═══════════════════════════════════════════════════════════════"
        echo "  Host:     ${db_host}"
        echo "  Puerto:   ${db_port}"
        echo "  Base:     ${db_name}"
        echo "  Usuario:  ${db_user}"
        echo "  Password: ${db_pass}"
        echo ""
        echo "  mysql -h ${db_host} -P ${db_port} -u ${db_user} -p'${db_pass}' ${db_name}"
        echo "═══════════════════════════════════════════════════════════════"
        return 0
    fi

    command -v xmlstarlet >/dev/null || { print_error "$MSG_ERR_NO_XMLSTARLET"; return 1; }

    print_info "$MSG_INFO_IMPORT_SEQUEL"

    # Cerramos Sequel Ace para que recargue Favorites.plist al abrir
    osascript -e 'quit app "Sequel Ace"' 2>/dev/null || true

    local conn_name="local - ${project_name}"
    # id único de la favorita (nanosegundos), enlaza la entrada del keychain con el XML
    local conn_id
    conn_id=$(python3 -c 'import time; print(int(time.time()*1_000_000_000))')
    local service="Sequel Ace : ${conn_name} (${conn_id})"
    local account="${db_user}@${db_host}/${db_name}"

    # Guardamos la contraseña en el keychain de macOS, autorizando a Sequel Ace a leerla
    security delete-generic-password -a "$account" -s "$service" 2>/dev/null || true
    security add-generic-password \
        -a "$account" \
        -s "$service" \
        -w "$db_pass" \
        -U \
        -T "/Applications/Sequel Ace.app/Contents/MacOS/Sequel Ace" \
        -T "/Applications/Sequel Ace.app/Contents/MacOS/SequelAceTunnelAssistant"

    local fav_path="$HOME/Library/Containers/com.sequel-ace.sequel-ace/Data/Library/Application Support/Sequel Ace/Data/Favorites.plist"

    # Creamos el Favorites.plist si aún no existe
    if [[ ! -f "$fav_path" ]]; then
        mkdir -p "$(dirname "$fav_path")"
        cat >"$fav_path" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Favorites Root</key>
  <dict>
    <key>Children</key>
    <array></array>
    <key>IsExpanded</key><true/>
    <key>Name</key><string>FAVORITOS</string>
  </dict>
</dict>
</plist>
EOF
    else
        # Copia de seguridad antes de modificar
        cp "$fav_path" "${fav_path}.bak.$(date +%s)"
    fi

    # Eliminamos cualquier favorita previa con el mismo nombre (re-ejecución limpia)
    xmlstarlet ed -L \
        -d "//string[.='${conn_name}']/preceding-sibling::key[.='name']/parent::dict" \
        "$fav_path"

    # Insertamos un marcador en el array de favoritas y luego lo sustituimos por el dict real
    local array_xpath="/plist/dict/key[.='Favorites Root']/following-sibling::dict/key[.='Children']/following-sibling::array"
    xmlstarlet ed -L --subnode "$array_xpath" -t elem -n dict -v "__IMPORT__" "$fav_path"

    local fav_dict
    fav_dict=$(cat <<XML
        <key>allowDataLocalInfile</key><integer>0</integer>
        <key>colorIndex</key><integer>4</integer>
        <key>database</key><string>${db_name}</string>
        <key>enableClearTextPlugin</key><integer>0</integer>
        <key>host</key><string>${db_host}</string>
        <key>id</key><integer>${conn_id}</integer>
        <key>name</key><string>${conn_name}</string>
        <key>port</key><string>${db_port}</string>
        <key>socket</key><string></string>
        <key>sshHost</key><string></string>
        <key>sshKeyLocation</key><string></string>
        <key>sshKeyLocationEnabled</key><integer>0</integer>
        <key>sshPort</key><string></string>
        <key>sshUser</key><string></string>
        <key>sslCACertFileLocation</key><string></string>
        <key>sslCACertFileLocationEnabled</key><integer>0</integer>
        <key>sslCertificateFileLocation</key><string></string>
        <key>sslCertificateFileLocationEnabled</key><integer>0</integer>
        <key>sslKeyFileLocation</key><string></string>
        <key>sslKeyFileLocationEnabled</key><integer>0</integer>
        <key>timeZone</key><string></string>
        <key>timeZoneMode</key><integer>0</integer>
        <key>type</key><integer>0</integer>
        <key>useSSL</key><integer>0</integer>
        <key>user</key><string>${db_user}</string>
XML
)
    perl -0777 -pe 's{<dict>__IMPORT__</dict>}{<dict>'"$fav_dict"'</dict>}s' -i "$fav_path"

    # Reformateamos el plist
    xmlstarlet fo -s 2 -o "$fav_path" > "${fav_path}.pretty" && mv "${fav_path}.pretty" "$fav_path"

    print_success "$MSG_SUCCESS_SEQUEL_IMPORTED '${conn_name}'"
    open -a "Sequel Ace"
}
