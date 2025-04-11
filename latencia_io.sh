#!/bin/bash
cd /usr/local/mon_IO
L=latencia_io.data
sleep $((RANDOM % 10 + 1))
timeout 30 ioping -c 10 . 2>&1 > $L
read avgg avgg_u mdevv mdevv_u <<< $(grep mdev $L | awk '{print $6,$7,$12,$13}' | tr '.' ',')
d=$(date +"%Y-%m-%d %H:%M")
HN=`hostname`
LH=$L.historico.$HN
printf "%s;%s;%s;%s;%s\n" "$d" $avgg $avgg_u $mdevv $mdevv_u >> $LH
if [ $(stat -c%s "$LH") -gt $((1 * 1024 * 1024)) ]; then
    mv $LH $LH.old
fi
#------------------- upload
sleep $((RANDOM % 10 + 1))
#Normally, git pull = git fetch + git merge.
git pull --rebase
d=`date`
git commit -m "$HN: updates a $d" -a
git push -u origin main

