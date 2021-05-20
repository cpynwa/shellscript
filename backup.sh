#!/bin/sh

#실행시각
NOW_DATE=`date`

#백업날짜
BACKUP_DATE=`date +"%Y%m%d"`

#웹루트
LABS=/opt/unetlab/labs
TMP=/opt/unetlab/tmp

#백업파일을 저장할 경로
BACKUP_DIR=/opt/unetlab/backup

# 오래된 백업데이터 삭제(3일 이상 된 것)
find ${BACKUP_DIR}/ -mtime +3 -exec rm -f {} \;

#MySQL백업
# mysqldump -usampledb -psampledbpass sampledb > ${BACKUP_DIR}/${BACKUP_DATE}.sql

#웹소스백업
tar zcvf ${BACKUP_DIR}/${BACKUP_DATE}labs.tar.gz ${LABS}
tar zcvf ${BACKUP_DIR}/${BACKUP_DATE}tmp.tar.gz ${TMP}

scp -rp ${BACKUP_DIR}/${BACKUP_DATE}labs.tar.gz root@10.1.112.97:/opt/unetlab/backup
scp -rp ${BACKUP_DIR}/${BACKUP_DATE}tmp.tar.gz root@10.1.112.97:/opt/unetlab/backup

#소유주 및 권한변경(타 계정의 접근 차단용)
chown -R root.root ${BACKUP_DIR}
chmod -R 700 ${BACKUP_DIR}

#메일 발송 (수신메일추가는 공백으로 구분하여 마지막에 열거)
# echo "백업시각: ${NOW_DATE}\n백업경로: ${BACKUP_DIR}\n\n위와 같이 DB와 웹파일이 백업되었습니다." | mail -a "From:서버관리자 <noreply@sample.com>" -a "Content-Type: text/plain; charset='UTF-8'" -s "자동서버백업안내" manager@sample.com

exit 0
