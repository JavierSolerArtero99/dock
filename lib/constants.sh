#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
DOCKER_COMPOSE="docker compose"
DOCK_ENV=".dock.env"

# Messages - Errors
MSG_ERR_NOT_LARAVEL="❌ No es un proyecto Laravel (no se encontró artisan)"
MSG_ERR_UNKNOWN_CMD="❌ Comando desconocido:"

# Messages - Warnings
MSG_WARN_FILE_EXISTS="ya existe"
MSG_WARN_NO_ENV="⚠️  No existe $DOCK_ENV, ejecuta './dock init' primero"
MSG_WARN_DESTROY="⚠️  Esta acción eliminará:"
MSG_WARN_DESTROY_CONTAINERS="  🗑️  Todos los contenedores del proyecto"
MSG_WARN_DESTROY_VOLUMES="  🗑️  Todos los volúmenes (incluyendo base de datos)"
MSG_WARN_DESTROY_IMAGES="  🗑️  Todas las imágenes construidas"

# Messages - Info
MSG_INFO_PROJECT="📂 Proyecto actual:"
MSG_INFO_INIT="🔧 Inicializando Docker en:"
MSG_INFO_VERIFY_ENV="🔍 Verificando .env de Laravel..."
MSG_INFO_LIFTING="🚀 Levantando contenedores para:"
MSG_INFO_STOPPING="🛑 Deteniendo contenedores..."
MSG_INFO_RESTARTING="🔄 Reiniciando contenedores..."
MSG_INFO_DELETING="🗑️  Eliminando todo..."
MSG_INFO_CANCELLED="↩️  Cancelado"
MSG_INFO_BUILDING="🔨 Construyendo imágenes..."
MSG_INFO_REBUILDING="🔨 Reconstruyendo imágenes..."
MSG_INFO_WAITING_MYSQL="⏳ Esperando a MySQL..."
MSG_INFO_INSTALLING_DEPS="📦 Instalando dependencias..."
MSG_INFO_GENERATING_KEY="🔑 Generando APP_KEY..."
MSG_INFO_RUNNING_MIGRATIONS="🗃️  Ejecutando migraciones..."
MSG_INFO_INSTALLING="📥 Instalando proyecto:"
MSG_INFO_INSTALLING_NODE_DEPS="📦 Instalando dependencias de Node..."
MSG_INFO_VITE_DEV="⚡ Iniciando servidor de desarrollo Vite..."
MSG_INFO_VITE_BUILD="📦 Compilando assets para producción..."

# Messages - Success
MSG_SUCCESS_CREATED="✅ Creado:"
MSG_SUCCESS_CREATED_ENV="✅ Creado .env desde .env.example"
MSG_SUCCESS_INIT="✅ Inicialización completada"
MSG_SUCCESS_CONTAINERS_UP="✅ Contenedores levantados"
MSG_SUCCESS_CONTAINERS_DOWN="✅ Contenedores detenidos"
MSG_SUCCESS_CONTAINERS_RESTART="✅ Contenedores reiniciados"
MSG_SUCCESS_DELETED="✅ Todo eliminado"
MSG_SUCCESS_BUILD="✅ Imágenes reconstruidas"
MSG_SUCCESS_INSTALL="🎉 ¡Instalación completada!"
MSG_SUCCESS_VITE_BUILD="✅ Assets compilados correctamente"
MSG_SUCCESS_LARAVEL_STARTED="✅ Servidor Laravel iniciado"
MSG_SUCCESS_VITE_STARTED="✅ Servidor Vite iniciado"

# Messages - Prompts
MSG_PROMPT_CONFIRM="¿Estás seguro? (y/N): "

# Messages - Services
MSG_SERVICES_HEADER="🌐 Servicios disponibles:"
MSG_SERVICES_APP="  🚀 App:     http://localhost:"
MSG_SERVICES_VITE="  ⚡ Vite:    http://localhost:"
MSG_SERVICES_MAILPIT="  📧 Mailpit: http://localhost:"

# Help text for env configuration
MSG_ENV_CONFIG_HEADER="Configura estas variables en"
MSG_ENV_CONFIG_DB="DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret"
MSG_ENV_CONFIG_MAIL="MAIL_MAILER=smtp
MAIL_HOST=mail
MAIL_PORT=1025"

