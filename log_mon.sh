#!/bin/bash

# 하는 일 : 로그 디텍토리의 용량을 감시
# 1. 로그 디렉토리의 크기를 확인
# 2. 크기가 1기가 이상일 경우 관리자에게 알림
# 3. 1기가 미만일 결우 아무 것도 안함

DIR="/var/log/nginx"
SIZE="$(du -m ${DIR} | awk '{print $1}')"
HOST="$(hostname)"

if [ ${SIZE} -ge 1024 ]
then
	TEXT="${DIR} 사용량이 1기가가 넘었습니다!"
	/root/SHELL/tel_push.sh "${HOST}" "${TEXT}"
fi
