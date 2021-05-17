#!/bin/bash

## telegram bot으로 메시지를 보내는 쉘 스크립트
## 2개의 파라미터가 필요함
## 파라미터 두개가 안될 경우 사용방법을 출력하고 스크립트를 종료
## 1. 서버 호스트 이름
## 2. 메세지
## 실행 결과는 현재 날짜/시작, 서버이름, 지정한 메세지를 텔레그램으로 보냄

# 파라미터 확인
if [ $# -ne 2 ]
then
	echo
	echo "Usage "
	echo "$0 {HOSTNAME} {MESSAGES}"
	echo
	echo "example) "
	echo "$0 \"cent1\" \"/var/log/nginx 파티션을 확인하세요\""
	echo
	exit 0
fi

# 텔레그램 봇 관련 정보
ID="nnnnnnnn"
APT_TOKEN="nnnnnnnnnn:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
URL="https://api.telegram.org/bot${APT_TOKEN}/sendMessage"

# 날짜
DATE="$(date "+%Y-%m-%d %H:%M")"

# 보낼 메세지 작성
TEXT="${DATE} [$1] $2"

# 메세지 보내기
curl -s -d "chat_id=${ID}&text=${TEXT}" ${URL} > /dev/null