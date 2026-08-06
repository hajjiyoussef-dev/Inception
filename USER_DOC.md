# User Documentation — Inception

> This document is intended for end users and administrators who want to run, access, and manage the Inception stack. No deep technical knowledge is required.

---

## 1. What Services Are Provided?

The Inception stack runs several services, each in its own container. Here is what each one does:

| Service | What it does |
|---|---|
| **NGINX** | The front door of the entire stack. All traffic goes through it via HTTPS (port 443). |
| **WordPress** | The main website and blog platform. This is what your visitors see. |
| **MariaDB** | The database that stores all WordPress content (posts, users, settings, etc.). It is not directly accessible from the outside. |
| **Redis** | A cache layer that speeds up WordPress by storing frequently accessed data in memory. It works silently in the background. |
| **vsftpd (FTP)** | Allows file uploads and management of WordPress files via an FTP client. |
| **Adminer** | A lightweight web interface to browse and manage the database directly from your browser. |
| **Static Website** | A simple standalone web page served independently from WordPress. |
| **Portainer** | A visual dashboard to monitor and manage all running Docker containers. |

---

## 2. Starting and Stopping the Project

All commands must be run from the **root of the repository** (where the `Makefile` is located).

### Start the stack

```bash
make
```

This will build all Docker images (if not already built) and start all containers in the background. The first run may take a few minutes.

### Stop the stack (keep data)

```bash
make down
```

This stops and removes the containers, but your data (database, WordPress files) is preserved in Docker volumes.

### Stop and wipe everything

```bash
make fclean
```

> ⚠️ **Warning:** This removes all containers, images, **and volumes**. All WordPress content and database data will be permanently deleted.

### Rebuild from scratch

```bash
make re
```

Equivalent to `make fclean` followed by `make`. Use this when you want a completely clean environment.

---

## 3. Accessing the Services

Before accessing anything, make sure your `/etc/hosts` file contains the following line:

```
127.0.0.1   yhajji.42.fr
```

> On Linux/macOS this file is at `/etc/hosts`. On Windows it is at `C:\Windows\System32\drivers\etc\hosts`. Editing it requires administrator privileges.

> Your browser will show a **security warning** about the TLS certificate. This is expected — the project uses a self-signed certificate. Click "Advanced" → "Proceed anyway" (or equivalent in your browser).

### Service URLs

| Service | URL | Notes |
|---|---|---|
| **WordPress (main site)** | `https://yhajji.42.fr` | The public-facing website |
| **WordPress Admin Panel** | `https://yhajji.42.fr/wp-admin` | Log in with your WordPress admin credentials |
| **Adminer (database UI)** | `https://yhajji.42.fr/adminer` | Log in with your database credentials |
| **Static Website** | `https://yhajji.42.fr/static` | Simple standalone page |
| **Portainer (Docker UI)** | `https://yhajji.42.fr:9443` | Log in with your Portainer admin credentials |
| **FTP** | `ftp://yhajji.42.fr` (port 21) | Use an FTP client such as FileZilla |

---

## 4. Locating and Managing Credentials

All credentials are defined in the `.env` file at the root of the repository. This file is **never committed to Git** for security reasons.

### Where to find the `.env` file

```
inception/
├── .env          ← credentials live here
├── Makefile
└── srcs/
```

If the file does not exist, copy the example and fill in your values:

```bash
cp .env.example .env
```

### Credentials overview

| What | Variable(s) in `.env` |
|---|---|
| WordPress admin username | `WP_ADMIN_USER` |
| WordPress admin password | `WP_ADMIN_PASSWORD` |
| WordPress admin email | `WP_ADMIN_EMAIL` |
| Database name | `MYSQL_DATABASE` |
| Database user | `MYSQL_USER` |
| Database user password | `MYSQL_PASSWORD` |
| Database root password | `MYSQL_ROOT_PASSWORD` |
| FTP username / password | `FTP_USER` / `FTP_PASSWORD` |

### Changing a password

1. Edit the `.env` file with your new value.
2. Run `make re` to rebuild and apply the changes.

> Never share your `.env` file or commit it to a public repository.

---

## 5. Checking That the Services Are Running Correctly

### Quick status check

```bash
docker compose -f srcs/docker-compose.yml ps
```

All services should show a status of **Up**. Example output:

```
NAME          STATUS          PORTS
nginx         Up              0.0.0.0:443->443/tcp
wordpress     Up
mariadb       Up
redis         Up
ftp           Up              0.0.0.0:21->21/tcp
adminer       Up
static        Up
portainer     Up              0.0.0.0:9443->9443/tcp
```

### View logs for a specific service

```bash
docker logs <container_name>
```

Examples:

```bash
docker logs nginx        # Check NGINX access/error logs
docker logs wordpress    # Check WordPress / php-fpm logs
docker logs mariadb      # Check database logs
```

### Check from the browser

| Check | How |
|---|---|
| WordPress is up | Visit `https://yhajji.42.fr` — the site should load |
| Admin panel works | Visit `https://yhajji.42.fr/wp-admin` and log in |
| Database is reachable | Visit `https://yhajji.42.fr/adminer` and log in |
| Portainer is running | Visit `https://yhajji.42.fr:9443` — the dashboard should appear |

### If a service is not running

1. Check its logs: `docker logs <container_name>`
2. Restart only that service: `docker compose -f srcs/docker-compose.yml restart <service_name>`
3. If the issue persists, do a full rebuild: `make re`