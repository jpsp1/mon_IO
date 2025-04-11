#!/bin/bash
cd /usr/local/mon_IO
L=latencia_io.data
sleep $((RANDOM % 10 + 1))
timeout 30 ioping -c 10 . 2>&1 > $L
read avgg avgg_u mdevv mdevv_u <<< $(grep mdev $L | awk '{print $6,$7,$12,$13}' | tr '.' ',')
d=$(date +"%Y-%m-%d %H:%M")
LH=$L.historico.`hostname`
printf "%s;%s;%s;%s;%s\n" "$d" $avgg $avgg_u $mdevv $mdevv_u >> $LH
if [ $(stat -c%s "$LH") -gt $((1 * 1024 * 1024)) ]; then
    mv $LH $LH.old
fi
#------------------- upload
git pull
d=`date`
git commit -m "updates a $d" -a
git push -u origin main

