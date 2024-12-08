FROM debian:bookworm

# 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y apache2 php php-mysql mariadb-client wget && \
    rm -rf /var/lib/apt/lists/*

# Adminer 다운로드 및 설치
RUN mkdir -p /var/www/html && \
    wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/index.php && \
    rm -f /var/www/html/index.html  # 기본 index.html 제거

# Apache 설정 파일에 ServerName 추가
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Apache 포트 설정
EXPOSE 8080

# Apache 포트 변경 및 설정
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/:80>/:8080>/' /etc/apache2/sites-available/000-default.conf

# Adminer 접근 권한 설정
COPY conf/adminer.conf /etc/apache2/conf-available/adminer.conf
RUN a2enconf adminer

# 파일 권한 설정
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Apache 실행
CMD ["apachectl", "-D", "FOREGROUND"]
