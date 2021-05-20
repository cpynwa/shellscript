#!/bin/bash

## 변수지정
TODAY=${/bin/date +%Y.%m.%d}
PUSH="root/SHELL/monitor/tel_push.sh"
LOG="/tmp/bak_report"
HOST=$(hostname)
WEB="/nfs/BACKUP/cent1/*.tgz"
DB1="/nfs/BACKUP/cent2/*.cent2.tgz"
DB2="/nfs/BACKUP/cent2/*DB.tgz"
STR="/nfs/BACKUP/cent3/*.tgz"
WBK_CNT=$(/usr/bin/ls -1 ${WEB} | /usr/bin/wc -1)
DBK_CNT1=$(/usr/bin/ls -1 ${DB1} | /usr/bin/wc -1)
DBK_CNT2=$(/usr/bin/ls -1 ${DB2} | /usr/bin/wc -1)
SBK_CNT=$(/usr/bin/ls -1 ${STR} | /usr/bin/wc -1)

## 함수 정의
# 인자를 두 개를 받아서 비교 메세지를 반환
# 인자1 : 백업이름
# 인자2 : 백업카운터
function chk_cnt() {
	# 인자를 변수에 할당
	NAME="$1"
	CNT="$2"
	
	# 백업카운터(${CNT})가 8이 아닐 경우 확인하도록 메세지
	# 8이 맞을 경우 문제가 없다는 메시지를 출력
	if [ "${CNT}" -eq 8 ]
	then
		/usr/bin/echo "${NAME} 백업파일 문제없음."
		/usr/bin/echo
	else
		/usr/bin/echo "${NAME} 백업파일이 8개가 아닙니다! 확인하세요!"
		/usr/bin/echo
	fi
}

## 레포팅파일 초기화
/usr/bin/rm -f "${LOG}"
/usr/bin/touch "${LOG}"

## 레포팅 메세지 작성
{
	/usr/bin/echo
	/usr/bin/echo "=================="
	/usr/bin/echo "     백업 확인"
	/usr/bin/echo "=================="
	/usr/bin/echo
	/usr/bin/echo "웹서버 백업파일"
	/usr/bin/ls -1 ${WEB} | /usr/bin/grep "${TODAY}"
	/usr/bin/echo
	/usr/bin/echo "DB서버 백업파일:"
	/usr/bin/ls -1 ${DB1} | /usr/bin/grep "${TODAY}"
	/usr/bin/ls -1 ${DB2} | /usr/bin/grep "${TODAY}"
	/usr/bin/echo
	/usr/bin/echo "Storage서버 백업파일:"
	/usr/bin/ls -1 ${STR} | /usr/bin/grep "${TODAY}"
	/usr/bin/echo
	
	# 백업 별 파일숫자 확인
	chk_cnt Web_System "${WBK_CNT}"
	chk_cnt DB_System "${DB_CNT1}"
	chk_cnt DB_Dump "${DBK_CNT2}"
	chk_cnt STORAGE_System "${SBK_CNT}"

}>|"${LOG}"

## 텔레그램으로 레포트 메세지를 보냄
"${PUSH}}" "${HOST}" "$(/usr/bin/cat "${LOG}")"
