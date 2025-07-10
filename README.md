# Inception Project

## Overview
The **Inception** project involves creating and managing multiple Docker containers to build a scalable web application environment. This project includes WordPress, Redis for caching, Adminer for database management, Prometheus and Grafana for monitoring, an FTP server, and a custom static website.

## Project Components

### Core Services
1. **Nginx**
   - Acts as a reverse proxy for all services.
   - Secures communication via SSL/TLS with self-signed certificates.
   - Limits requests and provides basic authentication for admin tools.

2. **WordPress**
   - Dynamic website setup using PHP and MariaDB.
   - Configured with Redis caching for improved performance.

3. **MariaDB**
   - Stores WordPress database information.
   - Configured with secure user credentials and isolated volumes.

### Bonus Services
1. **Redis**
   - Acts as an object cache for WordPress to reduce database queries.

2. **Adminer**
   - Provides a web-based interface for managing the MariaDB database.
   - Protected by basic authentication through Nginx.

3. **Static Website**
   - Custom static website implemented using HTML, CSS, JavaScript and Python.
   - Hosted and proxied by Nginx.

4. **FTP Server**
   - Enables file uploads to the WordPress volume.
   - Configured with secure credentials and passive mode support.

5. **Prometheus & Grafana**
   - **Prometheus**: Monitors metrics from various services like Nginx, WordPress, and Redis.
   - **Grafana**: Provides dashboards to visualize metrics.
   - Includes custom configurations and dashboards.

## Prerequisites

- Docker
- Docker Compose
- Colima (Mac)

Ensure the following directories exist on the host system:
- `/data/db_data`
- `/data/wordpress`
- `/data/grafana_data`

## Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd inception
   ```

2. Initialize the environment:
   ```bash
   ./scripts/init_inception.sh
   ```

3. Build the Docker containers:
   ```bash
   docker-compose -f srcs/docker-compose.yml build --no-cache
   ```

4. Start the services:
   ```bash
   docker-compose -f srcs/docker-compose.yml up -d
   ```

## Accessing Services

- **WordPress**: [https://junsan.42.fr/](https://junsan.42.fr/)
- **WordPressAdmin** : [https://junsan.42.fr/wp-admin](https://junsan.42.fr/wp-admin)
- **Adminer**: [https://junsan.42.fr/adminer/](https://junsan.42.fr/adminer/)
- **Static Website**: [https://junsan.42.fr/static/](https://junsan.42.fr/static/)
- **Prometheus**: [https://prometheus.junsan.42.fr/](https://prometheus.junsan.42.fr/)
- **Grafana**: [https://grafana.junsan.42.fr/](https://grafana.junsan.42.fr/)

## Features

### Security
- SSL/TLS encryption using self-signed certificates.
- Basic authentication for Adminer, Prometheus, and Grafana.
- Secure permissions on all host volumes.

### Monitoring
- Prometheus collects metrics from Nginx, Redis, and WordPress.
- Grafana visualizes metrics through custom dashboards.

### Performance
- Redis caching improves WordPress load times.
- Nginx handles static file serving efficiently.

## Known Issues
- Ensure `/etc/hosts` includes:
  ```
  127.0.0.1 junsan.42.fr
  127.0.0.1 grafana.junsan.42.fr
  127.0.0.1 prometheus.junsan.42.fr
  ```
- How to login Adminer
  ```
  server : <DB_HOST>
  user name : <USER>
  password : <PASSWORD>
  database : <DATABASE_NAME>
  ```
- Verify Docker Compose network configurations to avoid connectivity issues.

## Directory Structure
```
├── Makefile
├── README.md
├── scripts
│   ├── gen_config.sh
│   └── init_inception.sh
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── bonus
        │   ├── adminer
        │   │   ├── Dockerfile
        │   │   └── conf
        │   │       └── adminer.conf
        │   ├── ftp
        │   │   ├── Dockerfile
        │   │   └── conf
        │   │       └── vsftpd.conf
        │   ├── grafana
        │   │   ├── Dockerfile
        │   │   └── provisioning
        │   │       ├── dashboards
        │   │       │   ├── dashboard.yml
        │   │       │   └── wordpress_dashboard.json
        │   │       └── datasources
        │   │           └── datasource.yml
        │   ├── prometheus
        │   │   ├── Dockerfile
        │   │   └── prometheus.yml
        │   ├── redis
        │   │   ├── Dockerfile
        │   │   └── conf
        │   │       └── redis.conf
        │   └── static_website
        │       ├── Dockerfile
        │       └── app
        │           ├── app.py
        │           ├── requirements.txt
        │           └── templates
        │               └── index.html
        ├── mariadb
        │   ├── Dockerfile
        │   └── conf
        │       ├── entrypoint.sh
        │       └── my.cnf
        ├── nginx
        │   ├── Dockerfile
        │   └── conf
        │       └── nginx.conf
        └── wordpress
            ├── Dockerfile
            └── conf
                ├── entrypoint.sh
                └── www.conf
```

## Future Improvements
- Replace self-signed SSL certificates with Let's Encrypt certificates.
- Add automated tests for service availability.
- Implement load balancing with multiple Nginx containers.
