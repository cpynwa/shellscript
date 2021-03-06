#!/bin/bash

## 변수설정
HOST="$(/bin/hostname)"
LOG="/tmp/backup.log"
PUSH="/root/SHELL/monitor/tel_push.sh"
DATE="$(/bin/date +%Y.%m.%d)"
# 백업한 디렉토리/파일을 지정
BAK_LIST="/etc/my.cnf.d"
# 백업 디렉토리
BAK_PATH="/mnt/BACKUP/${HOST}"
# 백업 파일명
BAK_FILE="${BAK_PATH}/${DATE}_${HOST}.tgz"

# DB백업디렉토리
DB_BAK_PATH="/root/SHELL/BACKUP/xtrabackup_backupfiles"
# 디비백업파일명
DB_BAK_FILE="${BAK_PATH}/${DATE}_${HOST}_DB.tgz"

## 스토리지에 마운트
/bin/mount /mnt

## 로그파일생성
/usr/bin/touch "${LOG}"

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
	# DB dump
	/usr/bin/mariabackup \
			--backup \
			--no-lock \
			--target-dir="${DB_BAK_PATH}"
			
	# DB apply log
	/usr/bin/mariabackup \
			--prepare \
			--target-dir="${DB_BAK_PATH}"
	# p:퍼미션유지 P:절대경로유지
  /bin/tar czpPf "${BAK_FILE}" ${BAK_LIST}
	# DB백업 디렉토리 압축
  /bin/tar czpPf "${DB_BAK_FILE}" ${DB_BAK_PATH}
	
	# 백업파일 정보
	NAME="$(/bin/ls -al "${BAK_FILE}" | awk '{print $9}')"
	SIZE="$(/bin/ls -al "${BAK_FILE}" | awk '{print $5}')"
	/bin/echo "=== 백업 파일 정보 :"
	/bin/echo " | 파일명 : ${NAME}"
	/bin/echo " | 파일크기 : ${SIZE}"
	/bin/echo
	
	# DB백업파일 정보
	NAME="$(/bin/ls -al "${DB_BAK_FILE}" | awk '{print $9}')"
	SIZE="$(/bin/ls -al "${DB_BAK_FILE}" | awk '{print $5}')"
	/bin/echo "=== 백업 파일 정보 :"
	/bin/echo " | 파일명 : ${NAME}"
	/bin/echo " | 파일크기 : ${SIZE}"
	/bin/echo
	
	# 백업종료시각
	/bin/echo
	/bin/echo "=== 백업종료 시작 :"
	/bin/date
	/bin/echo

}>|"${LOG}"
## ---로그기록 끝

## 스토리지에 언마운트
/bin/umount /mnt

## 텔레그램으로 백업 로그를 전송
"${PUSH}" "${HOST}" "$(/bin/cat "${LOG}")"

## 로그파일 및 데이터베이스백업파일 삭제
/bin/rm -rf "${LOG}" "${DB_BAK_PATH}"