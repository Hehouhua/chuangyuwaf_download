#set -x
#使用前请确保Cookie和CSRFToken文件有效，可从浏览器copy过来，CSRFToken是Cookie中的csrftoken字段
t=$(date -d "yesterday" +%Y%m%d)
#t=$(date -d "7 days ago" +%Y%m%d) #7天前
cookie=`cat Cookie`
csrftoken=`cat CSRFToken`
if [ ! -d $t-攻击  ];then
  mkdir $t-攻击
fi
for d in $(cat domains)
do
	d=`echo $d | sed 's/\r//'`
	curl --no-progress-meter 'https://www.365cyd.com/log_download/make_download_link' -H "Cookie: $cookie" -H "X-CSRFToken: $csrftoken" -H "Referer: https://www.365cyd.com/log_download/list/" --data-raw "log_type=attack&date_index=$t&domain=$d&action_type=day"|jq -r '.data.download_link'|xargs -i wget {} -O "$t-攻击/$d-attack-$t.log.gz"
done