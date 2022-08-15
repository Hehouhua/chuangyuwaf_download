#set -x
#使用前请确保Cookie和CSRFToken文件有效，可从浏览器copy过来，CSRFToken是Cookie中的csrftoken字段
cookie=`cat Cookie`
csrftoken=`cat CSRFToken`
if [ ! -d 24小时内攻击日志 ];then
  mkdir 24小时内攻击日志
fi
for d in $(cat domains)
do
d=`echo $d | sed 's/\r//'`
	for i in $(seq 2 24)
	do
		t=$(date -d "$i hour ago"  +"%Y%m%d%H")
		curl --no-progress-meter 'https://www.365cyd.com/log_download/make_download_link' -H "Cookie: $cookie" -H "X-CSRFToken: $csrftoken" -H "Referer: https://www.365cyd.com/log_download/list/" --data-raw "log_type=attack&date_index=$t&domain=$d&action_type=hour"|jq -r '.data.download_link'|xargs -i wget {} -O "24小时内攻击日志/$d-attack-$t.log.gz"
	done
done