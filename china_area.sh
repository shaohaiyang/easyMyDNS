#!/bin/sh
PWD=`pwd`
TIME=3

gen_cnc(){
FILE=$1
rm -rf  $FILE.tmp
while read LINE;do
	LINE=`echo "$LINE"|awk '{print $1}'`
	echo "$LINE @ "
	echo -n "$LINE @ " >> $FILE.tmp
	whois $LINE|egrep "address"|xargs echo >> $FILE.tmp
	sleep $TIME
done < $FILE

egrep -i "Shangdi|Haidian|Mongolia|Cordelia|JPNIC|Beijing|Hebei|Langfang|TIANJIN|Jilin|Shijiazhuang|Jian Heng|Shenyang|Liaoning" $FILE.tmp > Huabei.cnc
egrep -i -v "Shangdi|Haidian|Mongolia|Cordelia|JPNIC|Beijing|Hebei|Langfang|TIANJIN|Jilin|Shijiazhuang|Jian Heng|Shenyang|Liaoning" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Henan|Zhenzhou|he nan" $FILE.tmp > Huazhong.cnc
egrep -i -v "Henan|Zhenzhou|he nan" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "GuangDe|Chengdu|Taiyuan|Shanxi" $FILE.tmp > Xi.cnc
egrep -i -v "GuangDe|Chengdu|Taiyuan|Shanxi" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "ShanDong|Qingdao|Hangzhou|pudong|Ningbo|Nanchang|ZheJiang|Shanghai|Jiangsu" $FILE.tmp > Huadong.cnc
egrep -i -v "ShanDong|Qingdao|Hangzhou|pudong|Ningbo|Nanchang|ZheJiang|Shanghai|Jiangsu" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Meizhou|guangxi|ShenZhen|ZhuHai|Guangzhou|Guangdong|Guang Zhou|SHUNDE|FOSHAN|GUANG DONG" $FILE.tmp > Huanan.cnc
egrep -i -v "Meizhou|guangxi|ShenZhen|ZhuHai|Guangzhou|Guangdong|Guang Zhou|SHUNDE|FOSHAN|GUANG DONG" $FILE.tmp > aaa
mv aaa $FILE.tmp

#cat $FILE.tmp >> Huabei.cnc
sed -r -i 's#@.*##g' H*.cnc
sed -r -i 's#@.*##g' Xi.cnc
}

gen_ctc(){
FILE=$1
rm -rf  $FILE.tmp
while read LINE;do
	LINE=`echo "$LINE"|awk '{print $1}'`
	echo "$LINE @ "
	echo -n "$LINE @ " >> $FILE.tmp
	whois $LINE|egrep "address"|xargs echo >> $FILE.tmp
	sleep $TIME
done < $FILE

egrep -i "Zhongguancun|Xing Guang|Ring Road|Winland|Haidian|EWXB|Xicheng|Shangdi|TJ|Dongsanhuan|Bejing|Chaoyang|Mongolia|Cordelia|JPNIC|Jianguomen|Harbin|Dalian|Daqing|heilongjiang|beijin|Hebei|Langfang|TIANJIN|Jilin|Shijiazhuang|Jian Heng|Shenyang|Liaoning" $FILE.tmp > Huabei.ctc
egrep -i -v "Zhongguancun|Xing Guang|Ring Road|Winland|Haidian|EWXB|Xicheng|Shangdi|TJ|Dongsanhuan|Bejing|Chaoyang|Mongolia|Cordelia|JPNIC|Jianguomen|Harbin|Dalian|Daqing|heilongjiang|beijin|Hebei|Langfang|TIANJIN|Jilin|Shijiazhuang|Jian Heng|Shenyang|Liaoning" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Henan|Zhenzhou|he nan" $FILE.tmp > Huazhong.ctc
egrep -i -v "Henan|Zhenzhou|he nan" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Sichuan|GanSu|XIAN|Gaoxin one Road|Ascendas Innovation|xining|Weiyang|LANZHOU|ChongQing|ningxia|Guiyang|GuangDe|Chengdu|Taiyuan|Shanxi" $FILE.tmp > Xi.ctc
egrep -i -v "Sichuan|GanSu|XIAN|Gaoxin one Road|Ascendas Innovation|xining|Weiyang|LANZHOU|ChongQing|ningxia|Guiyang|GuangDe|Chengdu|Taiyuan|Shanxi" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Songjiang|Guoshoujing|Nanjing|Suzhou|Su Zhou|Jiang Su|Wenzhou|Jinan|Shandong|Dongfang Road|Mansion|yiwujichang|Hefei|HONG KONG|West Lake|Anhui|JINAN|Wuhan|Hubei|Zhengzhou|Qingdao|Hangzhou|pudong|Ningbo|Nanchang|ZheJiang|Shanghai|Jiangsu" $FILE.tmp > Huadong.ctc
egrep -i -v "Songjiang|Guoshoujing|Nanjing|Suzhou|Su Zhou|Jiang Su|Wenzhou|Jinan|Shandong|Dongfang Road|Mansion|yiwujichang|Hefei|HONG KONG|West Lake|Anhui|JINAN|Wuhan|Hubei|Zhengzhou|Qingdao|Hangzhou|pudong|Ningbo|Nanchang|ZheJiang|Shanghai|Jiangsu" $FILE.tmp > aaa
mv aaa $FILE.tmp

egrep -i "Fujian|Xia men|Shantou|Fuzhou|Fujian|Dongguan|Xiamen|Xia men|HaiNan|Meizhou|guangxi|ShenZhen|ZhuHai|Guangzhou|Guangdong|Guang Zhou|SHUNDE|FOSHAN|GUANG DONG" $FILE.tmp > Huanan.ctc
egrep -i -v "Fujian|Xia men|Shantou|Fuzhou|Fujian|Dongguan|Xiamen|Xia men|HaiNan|Meizhou|guangxi|ShenZhen|ZhuHai|Guangzhou|Guangdong|Guang Zhou|SHUNDE|FOSHAN|GUANG DONG" $FILE.tmp > aaa
mv aaa $FILE.tmp

#cat $FILE.tmp >> Huadong.ctc
sed -r -i 's#@.*##g' H*.ctc
sed -r -i 's#@.*##g' Xi.ctc
}

gen_cnc $PWD/CNC
gen_ctc $PWD/CTC
gen_ctc $PWD/OTHER
#gen_cnc $PWD/CNC.tmp
#gen_ctc $PWD/OTHER.tmp
