#!/bin/bash
set -e
set -x  # 디버깅을 위한 명령어 출력 활성화

################################################################
# script.sh has to be run by ENTRYPOINT from mariadb Dockerfile
################################################################

# MariaDB 로그 파일 경로 설정
LOG_FILE="/var/lib/mysql/mariadb.err"

# Initialize the database if not already initialized
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Inception : ${MYSQL_DATABASE} database is being created."

    # MariaDB 데이터 디렉토리 초기화
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "Initializing MariaDB data directory..."
        mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    fi

    # Start MariaDB in the background with 로그 파일 출력
    mysqld_safe --defaults-file=/etc/mysql/my.cnf --skip-networking --log-error=${LOG_FILE} &
    pid="$!"

    # Wait for MariaDB to be ready
    for i in $(seq 1 30); do
        if mysqladmin ping -u root --silent; then
            echo "MariaDB is up and running."
            break
        fi
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    # Check if MariaDB started successfully
    if ! mysqladmin ping -u root --silent; then
        echo "MariaDB failed to start. Check the log file at ${LOG_FILE}."
        exit 1
    fi

    # Create database and user
    echo "Creating database and user..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL

    # Shutdown MariaDB
    echo "Shutting down MariaDB..."
    mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

    # Wait for MariaDB to shut down
    wait "$pid"
else
    echo "Inception : ${MYSQL_DATABASE} database is already there."
fi

# Start MariaDB in the foreground
echo "Starting MariaDB in the foreground..."
exec mysqld_safe --defaults-file=/etc/mysql/my.cnf --log-error=${LOG_FILE}
