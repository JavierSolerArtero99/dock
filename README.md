# Laravel Docker CLI

CLI reutilizable para dockerizar cualquier proyecto Laravel.

## Uso rápido

```bash
cd ~/proyectos/mi-app-laravel
dock init
dock install
```

## Comandos

| Comando | Descripción |
|---------|-------------|
| `dock init` | Inicializar configuración |
| `dock install` | Instalación completa |
| `dock up / up -d` | Levantar contenedores |
| `dock down` | Detener |
| `dock destroy` | Eliminar todo |
| `dock shell` | Bash en app |
| `dock mysql` | MySQL CLI |
| `dock artisan <cmd>` | Ejecutar artisan |
| `dock composer <cmd>` | Ejecutar composer |
| `dock npm <cmd>` | Ejecutar npm |
| `dock dev` | Iniciar Vite dev server |
| `dock build-assets` | Compilar assets |

## Servicios

- PHP 8.3 + artisan serve (puerto 8000)
- Node 20 + Vite (puerto 5173)
- MySQL 8.0 (puerto 3306)
- Mailpit (SMTP 1025, UI 8025)
