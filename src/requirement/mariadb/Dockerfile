FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# MariaDB 설정 복사
COPY conf/my.cnf /etc/mysql/my.cnf

EXPOSE 3306
# MariaDB 초기화 및 실행
CMD ["mysqld"]
