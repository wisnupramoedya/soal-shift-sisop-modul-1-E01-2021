#!/bin/bash

user=""

#a
echo 'soal a :'
grep "ticky" syslog.log | cut -d ':' -f 4-

#b
perma=""
permafix=""

for masalah in `grep "ERROR" syslog.log | cut -d ' ' -f 7- | rev | cut -d ' ' -f 2- | rev | tr ' ' '*'`
do
if [[ "$perma" != *"$masalah"* ]]
then
    perma+="${masalah} "
fi
done

for tes in `echo "$perma" | tr ' ' '\n'`
do

count=0

for typ in `grep "ERROR" syslog.log | cut -d ' ' -f 7- | rev | cut -d ' ' -f 2- | rev | tr ' ' '*' | tr ' ' '\n'`
do

if [ "$typ" = "$tes" ]
then
count=$((count+1))
fi

done

permafix+="$count#$tes,$count "
done
#e
echo 'Username,INFO,ERROR' > user_statistic.csv

#c
for entry in `grep -oP "\(\w+\.?\w+?\)" syslog.log | cut -c2- | rev | cut -c2- | rev`
do
if [[ "$user" != *"$entry"* ]]
then
    user+="${entry} "
fi
done

total=0

for pengguna in `echo "$user" | tr ' ' '\n' | sort`
do

erro=0
inf=0

for type in `grep -w "$pengguna" syslog.log`
do

if [ "$type" = "ERROR" ]
then
erro=$((erro+1))
elif [ "$type" = "INFO" ]
then
inf=$((inf+1))
fi

done

#e
echo $pengguna,$inf,$erro >> user_statistic.csv

total=$(($total+$inf+$erro))

done

#d
echo "Error,Count" > error_message.csv
echo $permafix | tr ' ' '\n' | sort -V -r | cut -d '#' -f 2- | tr '*' ' ' >> error_message.csv