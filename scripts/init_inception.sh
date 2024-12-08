#!/bin/bash

set -e

DOMAIN_NAME="junsan.42.fr"
USER_PATH="$HOME"
DATA_PATH="$USER_PATH/data"
DB_DATA_PATH="$DATA_PATH/db_data"
WORDPRESS_FILES_PATH="$DATA_PATH/wordpress"
GRAFANA_DATA_PATH="$DATA_PATH/grafana_data"

echo "Creating necessary directories..."
mkdir -p "$DB_DATA_PATH"
mkdir -p "$WORDPRESS_FILES_PATH"
mkdir -p "$GRAFANA_DATA_PATH"

# Set ownership and permissions
echo "Setting ownership and permissions..."
sudo chown -R "$(whoami):staff" "$DATA_PATH"
sudo chmod -R 755 "$DATA_PATH"

sudo chown -R "$(whoami):staff" "$DB_DATA_PATH"
sudo chmod -R 755 "$DB_DATA_PATH"

sudo chown -R "$(whoami):staff" "$WORDPRESS_FILES_PATH"
sudo chmod -R 755 "$WORDPRESS_FILES_PATH"

sudo chown -R "$(whoami):staff" "$GRAFANA_DATA_PATH"
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

echo "Updating /etc/hosts to route 127.0.0.1 to $DOMAIN_NAME..."
if ! grep -q "127.0.0.1 $DOMAIN_NAME" /etc/hosts; then
    echo "127.0.0.1 $DOMAIN_NAME" | sudo tee -a /etc/hosts > /dev/null
    echo "Added routing to /etc/hosts."
else
    echo "Routing already exists in /etc/hosts."
fi

echo "Initialization completed successfully!"
