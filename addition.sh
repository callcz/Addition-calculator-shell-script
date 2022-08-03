#!/bin/bash
## This is an addition shell script, Calculate decimals using command 'expr'.
## Writen by callcz 20220801
if [[ $1 == '--help' || $1 == '-h' || ! $1 ]]
then
	head -n3 $0
	echo "
Usage : $0 [OPTIONS] [FACTOR 0] [FACTOR 1] [FACTOR 2] ...
	example: \`$0 1 0.2 -3\` as '1+0.2+(-3)'.
options:
  -	Using shell pipes as input sources.
	example: \`echo 1 0.2| $0 - -3\` as '1 + 0.2 + (-3)'.
  --help,-h	List this help.
"
	exit
fi
#处理管道
jia=($*)
if [[ $1 == '-' ]]
then
	while read f
	do
		jia[0]=
		jia=($f ${jia[@]})
	done
fi
#检查参数格式是否数字
for ((i=0;i<${#jia[@]};i++))
do
#	echo $i
	for j in ${jia[$i]}
	do
		unset check_1
#		echo $j
#		echo ${#j}
		for ((k=0;k<${#j};k++))
		do
			l=${j:$k:1}
			check=0
			for m in {0..9} '.' '-'
			do
#				echo $m
#				echo $l
				if [[ $l == '.' && ${#j} == '1' ]]
				then
					check=0
				elif [[ $l == '-' && $k != '0' ]]
				then
					check=0
				elif [[ $m == $l ]]
				then
					check=1
				fi
				if [[ $l == '.' && $l == $m ]]
				then
					check_1=$(expr ${check_1:-0} + 1)
#					echo $i $k $check_1
				fi
			done
			if [[ $check == 0 ]]
			then
				echo \"$j\" is no a figure.
				exit $(expr $i + 1)
			fi
		done
		if [[ $check_1 -gt 1 ]]
		then
			echo "There are more then one '.' in '${jia[$i]}'"
			exit $(expr $i + 1)
		fi
	done
done
for i in {a..z}
do
	unset $i
done
#去除小数点，取小数位
for i in ${jia[@]}
do
	if [[ ${i#*.} != $i && ${i#*.} ]]
	then
		l=${#j}
		l=${l:-0}
		j=${i#*.}
		m=$j
		if [[ ${i:0:1} == '-' ]]
		then
			j='-'$j
			m=${j#-}
		fi
		if [[ ${#m} -gt $l ]]
		then
			l=${#m}
		fi
#		echo l=$l
#		echo j=$j
		xiaoshu=(${xiaoshu[@]} $j)
		k=${i%.*}
		zhengshu=(${zhengshu[@]} $k)
	else
		zhengshu=(${zhengshu[@]} ${i%.*})
		xiaoshu=(${xiaoshu[@]} 0)
	fi
	xiaoshuwei=$l
	xiaoshuwei=${xiaoshuwei:-1}
done
#echo zhengshu=${zhengshu[@]}
#echo xiaoshu=${xiaoshu[@]}
#echo xiaoshuwei=$xiaoshuwei
#整理位数加零
for i in {a..z}
do
	unset $i
done
for ((i=0;i<${#zhengshu[@]};i++))
do
	for j in ${zhengshu[$i]}
	do
		for ((k=0;k<$xiaoshuwei;k++))
		do
			zhengshu[$i]=${zhengshu[$i]}0
		done
	done
done
#echo zhengshu=${zhengshu[@]}
for i in {a..z}
do
	unset $i
done
for ((i=0;i<${#xiaoshu[@]};i++))
do
#	echo i=$i
	for j in ${xiaoshu[$i]}
	do
#		echo j=$j
		while [[ ${#xiaoshu[$i]} -lt $xiaoshuwei ]]
		do
			xiaoshu[$i]=${xiaoshu[$i]}0
		done
	done
done
#echo xiaoshu=${xiaoshu[@]}
#计算
for i in ${zhengshu[@]}
do
	deshu_zhengshu_bei=$(expr $deshu_zhengshu_bei + $i)
done
#echo deshu_zhengshu_bei=$deshu_zhengshu_bei
for i in ${xiaoshu[@]}
do
	deshu_xiaoshu_bei=$(expr $deshu_xiaoshu_bei + $i)
done
#echo deshu_xiaoshu_bei=$deshu_xiaoshu_bei
deshu_bei=$(expr $deshu_zhengshu_bei + $deshu_xiaoshu_bei)
#echo deshu_bei=$deshu_bei
deshu_zhengshu=${deshu_bei:0:$(expr ${#deshu_bei} - $xiaoshuwei)}
deshu_xiaoshu=${deshu_bei:0-$xiaoshuwei}
if [[ ! $deshu_zhengshu ]]
then
	deshu_zhengshu=0
fi
#去除小数位最后的零
while [[ ${deshu_xiaoshu:0-1} -eq 0 && ${#deshu_xiaoshu} -ne 1 ]]
do
	deshu_xiaoshu=${deshu_xiaoshu:0:$(expr ${#deshu_xiaoshu} - 1)}
#	echo $deshu_xiaoshu
done
#小数位前面去掉0才能比较
deshu_xiaoshu_kz=$deshu_xiaoshu
#echo ${deshu_xiaoshu_kz}
while [[ ${deshu_xiaoshu_kz:0:1} -eq 0 && $deshu_xiaoshu_kz -ne 0 ]]
do
	deshu_xiaoshu_kz=${deshu_xiaoshu_kz:1}
done
if [[ ! $deshu_xiaoshu || $deshu_xiaoshu_kz -eq 0 ]]
then
	deshu=$deshu_zhengshu
else
	deshu=$deshu_zhengshu.$deshu_xiaoshu
fi
echo $deshu
