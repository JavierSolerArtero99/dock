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
DOCK_CONFIG=".dock"
DOCK_ENV=".dock.env"

# Messages - Errors
MSG_ERR_NO_PROJECT="❌ No hay proyecto configurado."
MSG_ERR_PROJECT_NOT_EXISTS="❌ El proyecto configurado no existe:"
MSG_ERR_DIR_NOT_EXISTS="❌ El directorio no existe:"
MSG_ERR_SPECIFY_PATH="❌ Debes especificar la ruta del proyecto"
MSG_ERR_UNKNOWN_CMD="❌ Comando desconocido:"

# Messages - Warnings
MSG_WARN_NOT_LARAVEL="⚠️  No parece ser un proyecto Laravel (no se encontró artisan)"
MSG_WARN_NO_PROJECT="⚠️  No hay proyecto configurado"
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
MSG_INFO_RUNNING_FRESH="🗃️  Ejecutando migrate:fresh --seed..."
MSG_INFO_INSTALLING="📥 Instalando proyecto:"
MSG_INFO_INSTALLING_NODE_DEPS="📦 Instalando dependencias de Node..."
MSG_INFO_VITE_DEV="⚡ Iniciando servidor de desarrollo Vite..."
MSG_INFO_VITE_BUILD="📦 Compilando assets para producción..."

# Messages - Success
MSG_SUCCESS_PROJECT_SET="✅ Proyecto configurado:"
MSG_SUCCESS_CREATED="✅ Creado:"
MSG_SUCCESS_CREATED_ENV="✅ Creado .env desde .env.example"
MSG_SUCCESS_INIT="✅ Inicialización completada"
MSG_SUCCESS_CONTAINERS_UP="✅ Contenedores levantados"
MSG_SUCCESS_CONTAINERS_DOWN="✅ Contenedores detenidos"
MSG_SUCCESS_CONTAINERS_RESTART="✅ Contenedores reiniciados"
MSG_SUCCESS_DELETED="✅ Todo eliminado"
MSG_SUCCESS_MIGRATIONS="✅ Migraciones completadas"
MSG_SUCCESS_FRESH="✅ Base de datos recreada"
MSG_SUCCESS_BUILD="✅ Imágenes reconstruidas"
MSG_SUCCESS_INSTALL="🎉 ¡Instalación completada!"
MSG_SUCCESS_VITE_BUILD="✅ Assets compilados correctamente"
MSG_SUCCESS_LARAVEL_STARTED="✅ Servidor Laravel iniciado"
MSG_SUCCESS_VITE_STARTED="✅ Servidor Vite iniciado"

# Messages - Prompts
MSG_PROMPT_CONTINUE="¿Continuar de todos modos? (y/N): "
MSG_PROMPT_CONFIRM="¿Estás seguro? (y/N): "

# Messages - Help
MSG_HELP_USAGE="Uso: ./dock [comando] [opciones]"
MSG_HELP_USE="Uso: ./dock use /ruta/al/proyecto"
MSG_HELP_CONFIG_HEADER="Configuración:"
MSG_HELP_CONTAINERS_HEADER="Contenedores:"
MSG_HELP_ACCESS_HEADER="Acceso:"
MSG_HELP_LARAVEL_HEADER="Laravel:"
MSG_HELP_SETUP_HEADER="Setup:"
MSG_HELP_EXAMPLE_HEADER="Ejemplo de uso:"

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
