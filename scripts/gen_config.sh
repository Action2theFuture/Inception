#!/bin/bash

# config.yml 생성 스크립트
set -e

# 환경 변수 설정
OS=$(uname)
USER_PATH=$HOME
PROJECT_PATH=/inception
CONFIG_FILE="./config/config.yml"

# 디렉토리 및 파일 생성
mkdir -p "$(dirname "$CONFIG_FILE")"

# 환경 감지 및 설정
DATA_PATH="${USER_PATH}/data"
DESTINATION_PATH="${PROJECT_PATH}/data"

# config.yml 생성
cat > "$CONFIG_FILE" << EOF
mounts:
  - type: bind
    source: "${DATA_PATH}"
    destination: "${DESTINATION_PATH}"
    writable: true
mountType: "virtiofs"
EOF

echo "config.yml 파일이 성공적으로 생성되었습니다:"
cat "$CONFIG_FILE"

