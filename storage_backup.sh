#!/bin/bash

## 변수설정
HOST="$(/usr/bin/hostname)"
LOG="/tmp/backup.log"
PUSH="/root/SHELL/monitor/tel_push.sh"
DATE="$(/bin/date +%Y.%m.%d)"
# 백업한 디렉토리/파일을 지정
BAK_LIST="/etc/export /etx/nfx.conf /etc/nfsmount/conf"
# 백업 디렉토리
BAK_PATH="/mnt/BACKUP/${HOST}"
# 백업 파일명
BAK_FILE="${BAK_PATH}/${DATE}_${HOST}.tgz"

## 스토리지에 마운트
/usr/bin/mount /mnt

## 로그파일생성
/usr/bin/touch "${LOG}"

## 백업 디렉토리 확인
if [ -e "${BAK_PATH}" ]
then
	# 백업 디렉토리가 존재한다면
	/bin/echo "백업 디렉토리가 있습니다. 문제없음."
else
	# 백업 디렉토리가 업으면 생성
	/usr/bin/mkdir -p "${BAK_PATH}"
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
	/usr/bin/tar czpPf "{BAK_FILE}" ${BAK_LIST}
	
	# 백업파일 정보
	NAME="$(/usr/bin/ls -al "${BAK_FILE}" | awk '{print $9}')"
	SIZE="$(/usr/bin/ls -al "${BAK_FILE}" | awk '{print $5}')"
	/bin/echo "=== 백업 파일 정보 :"
	/bin/echo " | 파일명 : ${NAME}"
	/bin/echo " | 파일크기 : ${SIZE}"
	/bib/echo
	
	# 백업종료시각
	/bin/echo
	/bin/echo "=== 백업종료 시작 :"
	/bin/date
	/bin/echo

}>|"${LOG}"
## ---로그기록 끝

## 스토리지에 언마운트
/usr/bin/umount /mnt

## 텔레그램으로 백업 로그를 전송
"${PUSH}" "${HOST" "$(/usr/bin/cat "${LOG}")"

## 로그파일 삭제
/usr/bin/rm -f "${LOG}"