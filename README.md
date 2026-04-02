# CoonLabs DevCore

CoonLabs DevCore is a multi-service Docker development stack for local application workspaces. It provides language runtimes, databases, object storage, and admin UIs in one compose file so projects can share a predictable environment.

## 🧩 What's Included

- `panel` — CoonLabs access panel
- `portainer` for Docker administration
- `golang` for Go development
- `nodejs` for Node.js development
- `bun` for Bun development
- `python` for Python development
- `php83` for PHP 8.3 development
- `php80` for PHP 8.0 development
- `mysql` for MySQL 8.0
- `postgres` for PostgreSQL 13
- `mongodb` for MongoDB 7
- `redis` for Redis
- `minio` for S3-compatible object storage
- `minio-client` for MinIO administration
- `mailpit` for local email testing
- `pgadmin` for PostgreSQL administration
- `phpmyadmin` for MySQL administration
- `mongoexpress` for MongoDB administration

## 🌐 Network Model

All application services join the `kacoonet` bridge network. That means containers can talk to each other by service name without depending on host ports.

Persistent data is stored in named volumes for databases and admin tools, while the project source tree is mounted from `../Projects` into the runtime containers.

## 🗺️ Port Map

| Service        | Purpose                 | Host Port(s)   | Container Port(s) |
| -------------- | ----------------------- | -------------- | ----------------- |
| `panel`        | CoonLabs access panel   | `7000`         | `80`              |
| `portainer`    | Docker UI               | `9003`         | `9000`            |
| `golang`       | Go dev environment      | `8380`         | `8380`            |
| `nodejs`       | Node.js dev environment | `3010`, `5172` | `3010`, `5172`    |
| `bun`          | Bun dev environment     | `3020`, `5170` | `3020`, `5170`    |
| `python`       | Python dev environment  | `8290`, `5290` | `8290`, `5290`    |
| `php83`        | PHP 8.3 dev environment | `8183`, `5183` | `8000`, `5183`    |
| `php80`        | PHP 8.0 dev environment | `8180`, `5180` | `8000`, `5180`    |
| `mysql`        | MySQL database          | `3306`         | `3306`            |
| `postgres`     | PostgreSQL database     | `5432`         | `5432`            |
| `mongodb`      | MongoDB database        | `27017`        | `27017`           |
| `redis`        | Redis cache             | `6379`         | `6379`            |
| `minio`        | Object storage          | `9000`, `9001` | `9000`, `9001`    |
| `minio-client` | MinIO admin shell       | n/a            | shell             |
| `mailpit`      | Email testing           | `8025`, `1025` | `8025`, `1025`    |
| `pgadmin`      | PostgreSQL UI           | `5433`         | `80`              |
| `phpmyadmin`   | MySQL UI                | `3307`         | `80`              |
| `mongoexpress` | MongoDB UI              | `27017`        | `8081`            |

## 🚀 Quick Start

1. Make sure Docker and Docker Compose are installed.
2. From the project root, start the stack:

```bash
docker compose up -d --build
```

3. Stop the stack when you are done:

```bash
docker compose down
```

4. Remove named volumes only if you want to reset databases and app data:

```bash
docker compose down -v
```

## 🔗 Service URLs

- **CoonLabs Panel: http://localhost:7000**
- Portainer: http://localhost:9003
- MinIO console: http://localhost:9001
- MinIO API: http://localhost:9000
- Mailpit: http://localhost:8025
- pgAdmin: http://localhost:5433
- phpMyAdmin: http://localhost:3307
- mongo-express: http://localhost:27017

## 🛠️ Working With The Runtimes

### Go

Use `golang` for Go projects that live under `../Projects`. The container is set up for interactive development and shares the workspace through `/app`.

### Node.js

Use `nodejs` for Node-based projects. The service exposes `3010` and `5172`, which fits common application and dev-server workflows.

### Bun

Use `bun` for Bun-based projects. It mirrors the Node.js layout, shares the same project mount, and exposes `3020` and `5170` for development servers.

### Python

Use `python` for Python applications and tooling. The container publishes the `8290` and `5290` host ports for local services that your app may run.

### PHP 8.3 and PHP 8.0

Use `php83` and `php80` for PHP projects. Both mount the shared workspace and include the PHP-FPM and supervisor configuration needed for local development.

## 🗄️ Databases And Tools

- `mysql` is available on port `3306` with database, user, and password set to `kacoon`.
- `postgres` is available on port `5432` with user and password set to `kacoon`.
- `mongodb` is available on port `27017` with root credentials set to `kacoon`.
- `redis` is available on port `6379`.
- `phpmyadmin`, `pgadmin`, and `mongoexpress` provide browser-based administration.

## 📦 Object Storage And Mail

- `minio` provides object storage on ports `9000` and `9001`.
- `minio-client` provides an interactive `mc` shell for MinIO administration. Use `docker compose exec minio-client sh` to open it.
- `mailpit` captures outbound mail for local testing on ports `8025` and `1025`.

## 🧭 Panel

The `panel` service at http://localhost:7000 is a Vue single-page dashboard that lists every service in the stack, its ports, credentials, and direct open links. Use it as the main entry point when the stack is running.

## 📝 Notes

- Published ports should remain unique unless you intentionally share a host port for a specific service.
- Containers can communicate over `kacoonet` by service name.
- If you add a new runtime service, follow the existing pattern: build context, shared workspace volume, `kacoonet` network, and an unused host port pair.
