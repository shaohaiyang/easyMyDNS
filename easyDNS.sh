#!/bin/sh
PROG="easyDNS.sh"
PWD=`pwd`
TIME=1
#######################################
NAME_CONF="/var/named/chroot/etc/named.conf"
ACL_CONF="/var/named/chroot/etc/acl.conf"
ZONE_CONF="/var/named/chroot/etc/zone.conf"
#######################################
HB_FILE="Huabei"
HD_FILE="Huadong"
HN_FILE="Huanan"
XI_FILE="Xi"

## string
HB_STR="Zhongguancun|Xing Guang|Ring Road|Winland|Haidian|EWXB|Xicheng|Shangdi|TJ|Dongsanhuan|Bejing|Chaoyang|Mongolia|Cordelia|JPNIC|Jianguomen|Harbin|Dalian|Daqing|heilongjiang|beijin|Hebei|Langfang|TIANJIN|Jilin|Shijiazhuang|Jian Heng|Shenyang|Liaoning|Henan|Zhenzhou|he nan|Dong Cheng|Beiiing|Shi Jia Zhuang|He Bei|Lubei|Tangshan|Shangdi|Haidian|Mongolia|Cordelia|JPNIC|Beijing"

HD_STR="Songjiang|Guoshoujing|Nanjing|Suzhou|Su Zhou|Jiang Su|Wenzhou|Jinan|Shandong|Dongfang Road|Mansion|yiwujichang|Hefei|HONG KONG|West Lake|Anhui|JINAN|Wuhan|Hubei|Zhengzhou|Qingdao|Hangzhou|pudong|Ningbo|Nanchang|ZheJiang|Shanghai|Jiangsu|Hefei|Anhui|West Lake|Xu hui|shang hai|ShanDong|Qingdao"

HN_STR="Fujian|Xia men|Shantou|Fuzhou|Fujian|Dongguan|Xiamen|Xia men|HaiNan|Meizhou|guangxi|ShenZhen|ZhuHai|Guangzhou|Guangdong|Guang Zhou|SHUNDE|FOSHAN|GUANG DONG|Dongguan"

XI_STR="Sichuan|GanSu|XIAN|Gaoxin one Road|Ascendas Innovation|xining|Weiyang|LANZHOU|ChongQing|ningxia|Guiyang|GuangDe|Chengdu|Taiyuan|Shanxi"

## domain list
DOMAINS="
53kf.com
53kf.cn
53kf.net
53kf.com.cn
6d.com.cn
13jian.com
13jian.cn
13jian.com.cn
18sheng.com
18sheng.com.cn
168kf.com
53wang.com
53jz.com
53kfcard.com
53kfmall.com
53kfmall.cn
53llk.com
6drj.cn
wusankefu.cn
livechateverywhere.com
misoo.cn
yingxiaojun.cn"
########################################
get_apnic(){
FILE=$PWD/ip_apnic
CNC_FILE=$PWD/CNC
CTC_FILE=$PWD/CTC
TMP=/dev/shm/ip.tmp
rm -f $FILE
wget http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest -O $FILE
 
grep 'apnic|CN|ipv4|' $FILE | cut -f 4,5 -d'|'|sed -e 's/|/ /g' | while read ip cnt
do
       echo $ip:$cnt
       mask=$(cat << EOF | bc | tail -1
 
pow=32;
define log2(x) {
if (x<=1) return (pow);
pow--;
return(log2(x/2));
}
 
log2($cnt)
EOF
)
 
whois $ip@whois.apnic.net > $TMP.tmp
sed -n '/^inetnum/,/source/p' $TMP.tmp | awk '(/mnt-/ || /netname/)' >  $TMP
NETNAME=`grep ^netname $TMP | sed -e 's/.*:      \(.*\)/\1/g' | sed -e 's/-.*//g'|sed 's: ::g'`
 
egrep -qi "(CNC|UNICOM|WASU|NBIP|CERNET|CHINAGBN|CHINACOMM|FibrLINK|BGCTVNET|DXTNET|CRTC)" $TMP
  if [ $? = 0 ];then
      echo $ip/$mask >> $CNC_FILE
    else
      egrep -qi "(CHINATELECOM|CHINANET)" $TMP
      if [ $? = 0 ];then
        echo $ip/$mask >> $CTC_FILE
      else
         sed -n '/^route/,/source/p' $TMP.tmp | awk '(/mnt-/ || /netname/)' >  $TMP
         egrep -qi "(CNC|UNICOM|WASU|NBIP|CERNET|CHINAGBN|CHINACOMM|FibrLINK|BGCTVNET|DXTNET|CRTC)" $TMP
         if [ $? = 0 ];then
           echo $ip/$mask >> $CNC_FILE
         else
           egrep -qi "(CHINATELECOM|CHINANET)" $TMP
           if [ $? = 0 ];then
             echo $ip/$mask >> $CTC_FILE
           else
             echo "$ip/$mask $NETNAME" >> $PWD/OTHER
           fi
         fi
      fi
    fi
done
rm -rf $TMP $TMP.tmp
}
########################################
 
gen_zone(){
	FILE=$2
        [ ! -s $FILE ] && echo "$FILE file not found." && exit 0

	rm -rf  $FILE.zone
	while read LINE;do
	        LINE=`echo "$LINE"|awk '{print $1}'`
		echo "$LINE @ "
		echo -n "$LINE @ " >> $FILE.zone
		whois $LINE|egrep "address"|xargs echo >> $FILE.zone
		sleep $TIME
	done < $FILE
}
########################################

gen_area(){
	FILE=$2
        [ ! -s $FILE.zone ] && echo "$FILE.zone file not found." && exit 0

	STRING="none"
	echo $FILE|egrep -i -q "cnc"
	[ $? = 0 ] &&  STRING="cnc"
	echo $FILE|egrep -i -q "ctc"
	[ $? = 0 ] &&  STRING="ctc"
	echo $FILE|egrep -i -q "other"
	[ $? = 0 ] &&  STRING="other"
	
	[ $STRING = "none" ] && echo "Not cnc or ctc file" && exit 0

	cp -a $FILE.zone $FILE.tmp

	egrep -i "$HD_STR" $FILE.tmp > $HD_FILE.$STRING
	egrep -i -v "$HD_STR" $FILE.tmp > aaa
	mv aaa $FILE.tmp

	egrep -i "$HN_STR" $FILE.tmp > $HN_FILE.$STRING
	egrep -i -v "$HN_STR" $FILE.tmp > aaa
	mv aaa $FILE.tmp

	egrep -i "$XI_STR" $FILE.tmp > $XI_FILE.$STRING
	egrep -i -v "$XI_STR" $FILE.tmp > aaa
	mv aaa $FILE.tmp

	egrep -i "$HB_STR" $FILE.tmp > $HB_FILE.$STRING
	egrep -i -v "$HB_STR" $FILE.tmp > aaa
	mv aaa $FILE.tmp

	grep ^[0-9] $FILE.tmp |awk '{print $1}' >> $HD_FILE.$STRING
	sed -r -i 's#@.*##g' *.$STRING

	rm -rf $FILE.tmp
}
########################################

gen_bind(){
	for i in $HB_FILE $HD_FILE $HN_FILE $XI_FILE;do
		for ii in cnc ctc;do
			ZONE=$i"_"$ii
			STR=$STR"acl \"$ZONE\" {\t\t\t#easydns\n"
			STR=$STR$(grep '^[0-9]' $i.$ii|sed -r -e 's:^:\\t:g' -e 's:$:;\\t\\t\\t#easydns\\n:g' -e 's: ::g')
			STR=$STR"};\t\t\t\t\t#easydns\n"
		done
	done
	echo -en $STR > $ACL_CONF

	STR=""
	sed -r -i '/#easydns/d' $NAME_CONF

	for i in $HB_FILE $HD_FILE $HN_FILE $XI_FILE;do
		for ii in cnc ctc;do
			ZONE=$i"_"$ii
			STR=$STR"view \"$ZONE\" {\t\t\t\t\t#easydns\n"
			STR=$STR"\tmatch-clients {$ZONE;};\t\t\t#easydns\n"
			STR=$STR"\trecursion no;\t\t\t\t\t#easydns\n"

			for iii in $DOMAINS;do
				STR=$STR"\tzone \"$iii\" IN {\t\t\t\t#easydns\n"
				STR=$STR"\t\ttype master;\t\t\t\t#easydns\n"
				STR=$STR"\t\tfile \"$iii/$iii.$ZONE\";\t\t#easydns\n"
				STR=$STR"\t\tallow-update {none;};\t\t\t#easydns\n"
				STR=$STR"\t};\t\t\t\t\t\t#easydns\n"
			done
			STR=$STR"};\t\t\t\t\t\t\t#easydns\n"
		done
	done
	STR=$STR"view \"default\" {\t\t\t\t\t#easydns\n"
	STR=$STR"\tmatch-clients {any;};\t\t\t#easydns\n"
	for iii in $DOMAINS;do
		STR=$STR"\tzone \"$iii\" IN {\t\t\t\t#easydns\n"
		STR=$STR"\t\ttype master;\t\t\t\t#easydns\n"
		STR=$STR"\t\tfile \"$iii/$iii.default\";\t\t#easydns\n"
		STR=$STR"\t\tallow-update {none;};\t\t\t#easydns\n"
		STR=$STR"\t};\t\t\t\t\t\t#easydns\n"
	done
	STR=$STR"};\t\t\t\t\t\t\t#easydns\n"

	sed -r -i "/shaohy/a\#easydns\n$STR" $NAME_CONF
}
########################################

case $1 in
	apnic)
		get_apnic;;
	zone)
		[ $# -ne 2 ] && echo "Usage: $PROG $@ File" && exit 0
		gen_zone "$@";;
	area)
		[ $# -ne 2 ] && echo "Usage: $PROG $@ File" && exit 0
		gen_area "$@";;
	bind)
		gen_bind;;
	all)
		get_apnic
		gen_zone CNC
		gen_zone CTC
		gen_area CNC
		gen_area CTC
		gen_bind
		;;
	*)
		echo "Usage: $PROG {apnic|zone|area|bind}";;
esac
