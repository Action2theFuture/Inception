FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# MariaDB 설정 복사
COPY conf/my.cnf /etc/mysql/my.cnf

# 데이터 디렉토리 설정
VOLUME ["/var/lib/mysql"]

# 환경 변수 설정
ENV MYSQL_ROOT_PASSWORD_FILE=/run/secrets/db_root_password

# MariaDB 초기화 및 실행
CMD ["mysqld"]
