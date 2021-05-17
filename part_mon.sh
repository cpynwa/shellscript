#!/bin/bash

# 파티션별 사용량을 확인해서 80% 이상인 파티션이 있으면 관리자에게 메세지를 보냄
# 1. 파티션별 사용량을 확인
# 2. 크기를 비교해서 처리
# 3. use가 80%이상이면 관리자엑 ㅔ메세지
# 4. 80% 미만이면 아무 것도 안함

# TEXT변수에 보낼 메세지를 작성
TEXT="$(df -g | \
		awk '{
			gsub("%","");
			USE=$5;
			MNT=$6;
			if ( USE > 80 )
				print MNT,"파티션이 ",USE,"%를 사용 중입니다."
		}' |\
		grep -v "^[A-Z]")"
HOST="$(hostname)"

# 80%이상 디스크를 사용하는 파티션이 있을 경우
# TEXT변수의 내용 (메세지)를 관리자에게 보냄
if [ ${#TEXT} -gt 1 ]
then
	/root/SHELL/monitor/tel_push.sh "${HOST}" "${TEXT}"
fi
