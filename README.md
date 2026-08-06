*This project has been created as part of the 42 curriculum by yhajji.*

---

# Inception

## Description

**Inception** is a 42 school system administration project that deepens understanding of containerization by using **Docker** and **Docker Compose** to build a small but complete infrastructure of services from scratch.

The goal is to set up a multi-service environment inside a virtual machine, where each service runs in its own dedicated Docker container built from either **Alpine** or **Debian** (no pre-built images from Docker Hub allowed, except for alpine/debian base). All containers are orchestrated via a single `docker-compose.yml`.

### Services Included

#### Mandatory
| Service | Description |
|---|---|
| **NGINX** | The sole entry point to the infrastructure, configured with TLSv1.2/1.3 only |
| **WordPress + php-fpm** | The CMS, running without NGINX (php-fpm only) |
| **MariaDB** | The relational database backend for WordPress |

#### Bonus
| Service | Description |
|---|---|
| **Redis** | Object cache for WordPress, speeding up page loads |
| **vsftpd (FTP)** | FTP server pointing to the WordPress volume |
| **Adminer** | Lightweight web-based database management UI |
| **Static Website** | A simple custom static site served by a dedicated container |
| **Portainer** | Web-based Docker management UI for monitoring and controlling containers |

### Design Choices

#### Virtual Machines vs Docker
Virtual Machines emulate an entire operating system with their own kernel via a hypervisor, making them heavy, slow to boot, and resource-intensive. Docker containers, on the other hand, share the host kernel and are isolated at the process level using Linux namespaces and cgroups. This makes them lightweight, fast to start, and highly portable. Inception uses Docker because each service only needs its runtime dependencies — not a full OS — which fits perfectly with the microservice philosophy of this project.

#### Secrets vs Environment Variables
Environment variables are simple key-value pairs injected into a container's environment. They are convenient but can be exposed via `docker inspect`, logs, or child processes. Docker Secrets are files stored in an in-memory tmpfs filesystem (`/run/secrets/`) inside the container and are only available to services that explicitly request them. For sensitive data such as database passwords and credentials, this project uses **Docker Secrets** (via `.env` files that are never committed to git, and referenced securely) to avoid leaking credentials.

#### Docker Network vs Host Network
With the **host network**, the container shares the host's network stack directly — no isolation, no port mapping needed. With a **Docker network** (bridge mode), each container gets its own virtual network interface and communicates with other containers via service names (DNS). Inception uses a **custom bridge network** so that:
- Containers can resolve each other by name (e.g., `wordpress` can reach `mariadb` by hostname).
- No unnecessary ports are exposed to the host.
- The only public entry point is NGINX on port 443.

#### Docker Volumes vs Bind Mounts
Bind mounts link a specific path on the host to a path in the container — tightly coupling the container to the host filesystem. Docker Volumes are managed by Docker itself, stored under `/var/lib/docker/volumes/`, and are portable, easier to back up, and independent of the host directory structure. This project uses **named Docker Volumes** for the WordPress files and the MariaDB data directory, ensuring persistence across container restarts without depending on host paths.

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed on your machine (or VM).
- `make` utility available.
- A `.env` file at the root of the project (see `.env.example` for required variables).
- Add your domain to `/etc/hosts`:
  ```
  127.0.0.1   yhajji.42.fr
  ```

### Environment Setup

Copy the example environment file and fill in your values:
```bash
cp .env.example .env
```

Required variables include:
```
DOMAIN_NAME=yhajji.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=...
MYSQL_ROOT_PASSWORD=...
WP_ADMIN_USER=...
WP_ADMIN_PASSWORD=...
WP_ADMIN_EMAIL=...
```

### Build & Run

```bash
# Build all images and start all services
make

# Equivalent to:
docker compose -f srcs/docker-compose.yml up --build -d
```

### Stop & Clean

```bash
# Stop all containers
make down

# Stop and remove containers, volumes, and images
make fclean

# Full rebuild from scratch
make re
```

### Access the Services

| Service | URL |
|---|---|
| WordPress | `https://yhajji.42.fr` |
| Adminer | `https://yhajji.42.fr/adminer` |
| Static Website | `https://yhajji.42.fr/static` |
| Portainer | `https://yhajji.42.fr:9443` |
| FTP | `ftp://yhajji.42.fr` (port 21) |

> **Note:** NGINX uses a self-signed TLS certificate. Your browser will warn you — this is expected in a local dev environment.

---

## Resources

### Docker & Containerization
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Networking Overview](https://docs.docker.com/network/)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)

### Services
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI (wp-cli)](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [php-fpm Documentation](https://www.php.net/manual/en/install.fpm.php)
- [Redis Documentation](https://redis.io/docs/)
- [vsftpd Manual](https://security.appspot.com/vsftpd.html)
- [Adminer](https://www.adminer.org/)
- [Portainer Documentation](https://docs.portainer.io/)

### TLS / SSL
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)
- [OpenSSL Documentation](https://www.openssl.org/docs/)

### Articles & Tutorials
- [Linux Namespaces and cgroups explained](https://www.redhat.com/en/topics/containers/whats-a-linux-container)
- [VMs vs Containers — Red Hat](https://www.redhat.com/en/topics/containers/containers-vs-vms)
- [Understanding Docker Networking](https://www.docker.com/blog/understanding-docker-networking-drivers-use-cases/)

# AI Usage

AI was used as a learning and documentation assistant.

It was used for:

- Understanding Docker networking.
- Understanding Linux namespaces.
- Explaining Docker internals.
- Improving documentation.
- Reviewing Dockerfiles and Docker Compose configuration.
- Debugging configuration issues.

All implementation decisions, configuration files, and source code were written, tested, and validated manually.
