#!/bin/bash

## 변수설정
HOST="$(/bin/hostname)"
LOG="/var/log/syslog"
DATE="$(/bin/date +%Y.%m.%d)"
# 백업한 디렉토리/파일을 지정
BAK_LIST="/etc/nginx/sites-available/IMS /etc/systemd/system/gunicorn.service /home/eknow/IMS"
# 백업 디렉토리
BAK_PATH="/home/eknow/backup/${HOST}"
# 백업 파일명
BAK_FILE="${BAK_PATH}/${DATE}_${HOST}.tgz"


## 백업 디렉토리 확인
if [ -e "${BAK_PATH}" ]
then
        # 백업 디렉토리가 존재한다면
        /bin/echo "백업 디렉토리가 있습니다. 문제없음."
else
        # 백업 디렉토리가 업으면 생성
        /bin/mkdir -p "${BAK_PATH}"
fi

## --- 로그기록시작
{
        # 백업시작시작
        /bin/echo
        /bin/echo "=== 백업시작 시작 :"
        /bin/date
        /bin/echo

        # 이전 백업파일 삭제
        /bin/echo "=== 이전 백업파일 삭제 :"
        /bin/echo
        /usr/bin/find ${BAK_PATH} -mtime +7 -exec sh -c "ls -1 {};rm {}" \;
        /bin/echo

        ## 백업
        # p:퍼미션유지 P:절대경로유지
        /bin/tar czpPf "${BAK_FILE}" ${BAK_LIST}
        /usr/bin/scp -rp ${BAK_FILE} eknow@10.1.112.61:${BAK_FILE}


        # 백업파일 정보
        NAME="$(/bin/ls -al "${BAK_FILE}" | awk '{print $9}')"
        SIZE="$(/bin/ls -al "${BAK_FILE}" | awk '{print $5}')"
        /bin/echo "=== 백업 파일 정보 :"
        /bin/echo " | 파일명 : ${NAME}"
        /bin/echo " | 파일크기 : ${SIZE}"
        /bin/echo

        # 백업종료시각
        /bin/echo
        /bin/echo "=== 백업종료 시작 :"
        /bin/date
        /bin/echo

}>>"${LOG}"
## --- 로그기록 끝