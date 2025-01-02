#!/bin/bash

set -e

DOMAIN_NAME="junsan.42.fr"
PROMETHEUS_SUBDOMAIN="prometheus.junsan.42.fr"
GRAFANA_SUBDOMAIN="grafana.junsan.42.fr"
USER_PATH="$HOME"
DATA_PATH="$USER_PATH/data"
DB_DATA_PATH="$DATA_PATH/db_data"
WORDPRESS_FILES_PATH="$DATA_PATH/wordpress"
GRAFANA_DATA_PATH="$DATA_PATH/grafana_data"
ARCH="$(uname -m)"

# ARCH 값 매핑
case "$ARCH" in
    aarch64)
        ARCH="arm64"
        ;;
    x86_64)
        ARCH="amd64"
        ;;
    # 추가적인 아키텍처 매핑 필요시 여기서 추가
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

echo "Creating necessary directories..."
mkdir -p "$DB_DATA_PATH"
mkdir -p "$WORDPRESS_FILES_PATH"
mkdir -p "$GRAFANA_DATA_PATH"

# Set ownership and permissions
echo "Setting ownership and permissions..."
sudo chmod -R 755 "$DATA_PATH"

sudo chmod -R 755 "$DB_DATA_PATH"

sudo chmod -R 755 "$WORDPRESS_FILES_PATH"

sudo chmod -R 755 "$GRAFANA_DATA_PATH"

# Run the update_env.sh script
echo "Updating environment variables..."

ENV_FILE="./srcs/.env"

add_env_var() {
    local var_name="$1"
    local var_value="$2"
    if grep -q "^$var_name=" "$ENV_FILE"; then
        echo "$var_name already exists in $ENV_FILE"
    else
        echo "$var_name=$var_value" >> "$ENV_FILE"
        echo "Added $var_name to $ENV_FILE"
    fi
}

add_env_var "DATA_PATH" "$DATA_PATH"
add_env_var "DB_DATA_PATH" "$DB_DATA_PATH"
add_env_var "WORDPRESS_FILES_PATH" "$WORDPRESS_FILES_PATH"
add_env_var "GRAFANA_DATA_PATH" "$GRAFANA_DATA_PATH"

echo "Updating ARCH environment variable..."
add_env_var "ARCH" "$ARCH"

echo "Updating /etc/hosts to route 127.0.0.1 to $DOMAIN_NAME and subdomains..."

# Function to add a hostname to /etc/hosts if it doesn't already exist
add_host_entry() {
    local ip="$1"
    shift
    for host in "$@"; do
        if ! grep -q "^$ip\s\+$host" /etc/hosts; then
            echo "$ip $host" | sudo tee -a /etc/hosts > /dev/null
            echo "Added $host to /etc/hosts."
        else
            echo "Routing for $host already exists in /etc/hosts."
        fi
    done
}

# Add main domain and subdomains
add_host_entry "127.0.0.1" "$DOMAIN_NAME" "$PROMETHEUS_SUBDOMAIN" "$GRAFANA_SUBDOMAIN"

# Add Architecture

echo "Initialization completed successfully!"
