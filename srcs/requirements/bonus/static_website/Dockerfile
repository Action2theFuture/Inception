FROM debian:bookworm

# 작업 디렉토리 설정
WORKDIR /app

# Python 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 애플리케이션 소스 복사
COPY app/ /app/

# 필요한 Python 패키지 설치
# In Debian 12 (Bookworm), per PEP 668, 
# system-wide package installation using pip in a Python environment managed through the system package manager (apt) is restricted.
# so if you add the flag, --break-system-packages, option to force the package to install
RUN pip3 install --break-system-packages --no-cache-dir -r /app/requirements.txt

# python 명령어를 python3로 링크
RUN ln -s /usr/bin/python3 /usr/bin/python

# 포트 설정
EXPOSE 5000

# 애플리케이션 실행
CMD ["python", "app.py"]
