FROM debian:bookworm

# vsftpd 설치
RUN apt-get update && \
    apt-get install -y vsftpd && \
    rm -rf /var/lib/apt/lists/*

# vsftpd 설정 파일 복사
COPY /conf/vsftpd.conf /etc/vsftpd.conf

# FTP 사용자 생성 및 디렉토리 설정
RUN useradd -m ftpuser && \
    echo "ftpuser:ftp_password" | chpasswd && \
    mkdir -p /home/ftpuser/ftp && \
    chown ftpuser:ftpuser /home/ftpuser/ftp

# 포트 설정
EXPOSE 21 40000-40005

# vsftpd 실행
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
