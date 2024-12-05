#!/bin/bash

USER_PATH=$HOME
DATA_PATH="$USER_PATH/data"
DB_DATA_PATH="$DATA_PATH/db_data"
WORDPRESS_FILES_PATH="$DATA_PATH/wordpress"

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

# 확인 및 추가
add_env_var "DATA_PATH" "$DATA_PATH"
add_env_var "DB_DATA_PATH" "$DB_DATA_PATH"
add_env_var "WORDPRESS_FILES_PATH" "$WORDPRESS_FILES_PATH"