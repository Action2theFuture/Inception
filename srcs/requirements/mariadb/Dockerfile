FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY /conf/my.cnf /etc/mysql/my.cnf
COPY /conf/entrypoint.sh /usr/local/bin/db_entrypoint.sh

RUN chmod 755 /etc/mysql/my.cnf /usr/local/bin/db_entrypoint.sh

# 포트 노출
EXPOSE 3306

# 엔트리포인트 설정
ENTRYPOINT ["/usr/local/bin/db_entrypoint.sh"]
