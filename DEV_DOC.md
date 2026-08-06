# Developer Documentation — Inception

## 1. Setting Up the Environment from Scratch

### Prerequisites

Make sure the following tools are installed inside your VM:

| Tool | Check |
|---|---|
| Docker | `docker --version` |
| Docker Compose (plugin v2) | `docker compose version` |
| Make | `make --version` |

### Configuration file — `.env`

Create a `.env` file at the root of the repository and fill in the following variables:

```dotenv
# Domain
DOMAIN_NAME=yhajji.42.fr

# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=your_db_password
MYSQL_ROOT_PASSWORD=your_root_password

# WordPress
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=your_wp_password
WP_ADMIN_EMAIL=admin@yhajji.42.fr

# FTP
FTP_USER=ftpuser
```

> Never commit `.env` to Git — add it to `.gitignore`.

### Secrets

Sensitive passwords are passed to containers as Docker Secrets (mounted at `/run/secrets/` inside the container). The `secrets/` folder lives at the root of the repository:

```
secrets/
├── db_password.txt       ← MariaDB user password
├── db_root_password.txt  ← MariaDB root password
└── ftp_password.txt      ← FTP user password
```

Each file must contain only the password value, with no extra spaces or newlines:

```bash
echo -n "your_db_password"   > secrets/db_password.txt
echo -n "your_root_password" > secrets/db_root_password.txt
echo -n "your_ftp_password"  > secrets/ftp_password.txt
```

> Never commit the `secrets/` folder to Git — add it to `.gitignore`.

### `/etc/hosts`

Add the following line so your browser resolves the domain locally:

```bash
echo "127.0.0.1   yhajji.42.fr" | sudo tee -a /etc/hosts
```

---

## 2. Build and Launch with Makefile and Docker Compose

All commands are run from the **root of the repository**.

| Command | What it does |
|---|---|
| `make` | Creates data directories, builds all images, starts all containers |
| `make down` | Stops and removes containers (data and images are kept) |
| `make clean` | Stops containers and removes built images |
| `make fclean` | Removes containers, images, volumes, and host data directories |
| `make re` | Full `fclean` then `make` — clean rebuild from zero |

Internally, `make` runs:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

To rebuild and restart a single service without touching the others:

```bash
docker compose -f srcs/docker-compose.yml up --build -d <service_name>
```

---

## 3. Useful Commands to Manage Containers and Volumes

### Check status

```bash
# See all containers, their status and ports
docker compose -f srcs/docker-compose.yml ps
```

### Logs

```bash
# Follow logs for all services
docker compose -f srcs/docker-compose.yml logs -f

# Logs for one service
docker logs -f <container_name>
```

### Shell access inside a container

```bash
docker exec -it <container_name> sh
```

### Restart a single container

```bash
docker compose -f srcs/docker-compose.yml restart <service_name>
```

### Volume management

```bash
# List all volumes
docker volume ls

# Inspect a volume (shows its mount point on the host)
docker volume inspect <volume_name>

# Remove a volume manually (only when containers are stopped)
docker volume rm <volume_name>
```

---

## 4. Where Data Is Stored and How It Persists

| Data | Path inside the container | Path on the host (VM) |
|---|---|---|
| WordPress files | `/var/www/html` | `/home/yhajji/data/wordpress` |
| MariaDB database | `/var/lib/mysql` | `/home/yhajji/data/mariadb` |

Both volumes are declared as **named volumes with bind mounts** in `docker-compose.yml`, which maps container paths directly to fixed directories on the VM filesystem. When containers are stopped or removed, the data on the host path survives untouched. On the next `make`, the new containers mount the same directories and pick up all existing data.

Running `make fclean` **deletes** these host directories — all data is permanently lost.

**Redis** data is ephemeral by design — it is a cache, not a source of truth. Its contents are lost on container restart and WordPress falls back to the database automatically.

**Portainer** stores its configuration in a Docker-managed volume (`portainer_data`) that survives `make down` but is removed by `make fclean`.