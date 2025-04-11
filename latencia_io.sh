#!/bin/bash
L=/root/scripts/latencia_io.data
if [ $(stat -c%s "$L") -gt $((10 * 1024 * 1024)) ]; then
    mv $L $L.old
fi
sleep $((RANDOM % 10 + 1))
timeout 30 ioping -c 10 /root/scripts 2>&1 > $L
read avgg avgg_u mdevv mdevv_u <<< $(grep mdev $L | awk '{print $6,$7,$12,$13}' | tr '.' ',')
d=$(date +"%Y-%m-%d %H:%M")
printf "%s;%s;%s;%s;%s\n" "$d" $avgg $avgg_u $mdevv $mdevv_u >> $L.historico
cp $L.historico /tmp/


