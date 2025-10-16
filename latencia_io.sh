#!/bin/bash

################# outputs
# --- ficheiro  latencia_io.data.historico.<hostname>
#...
#2025-10-16 10:55;1,03;ms;120,9;us;2782;sect_R_sec;74;sect_W_sec
#2025-10-16 11:00;1,12;ms;132,7;us;2808;sect_R_sec;4120;sect_W_sec
#colunas
# data/hora
# tempo médio READ
# tempo médio WRITE
# IOS- READ 
# IOS- WRITE
#
# --- ficheiro  latencia_io.data.historico.<hostname>.carga 
#...
#2025-10-16 10:55;1760608519;1571548123;75362900
#2025-10-16 11:00;1760608820;1572393483;76603048
#colunas
# data/hora
#    sectors read, contador
#    sectors written, contador

cd /usr/local/mon_IO
L=latencia_io.data
sleep $((RANDOM % 10 + 1))
timeout 30 ioping -c 10 . 2>&1 > $L
read avgg avgg_u mdevv mdevv_u <<< $(grep mdev $L | awk '{print $6,$7,$12,$13}' | tr '.' ',')
d=$(date +"%Y-%m-%d %H:%M")
HN=`hostname`
LH=$L.historico.$HN
L2=${LH}.carga
#Field 6 - sectors read
#Field 10 - sectors written
R=`cat  /proc/diskstats | awk '{print $6}'|awk '{sum += $1} END {print sum}'`
W=`cat  /proc/diskstats | awk '{print $10}'|awk '{sum += $1} END {print sum}'`
R=`printf "%.0f\n" $R`
W=`printf "%.0f\n" $W`
IFS=';' read -r -a fruits <<< `tail -1 $L2`  
d=$(date +"%Y-%m-%d %H:%M")
d2=$(date +"%s")
secs=$[ $d2 - ${fruits[1]} ]
delta_R=$[  $R - ${fruits[2]} ]
delta_W=$[  $W - ${fruits[3]} ]
delta_R_PS=-1
delta_W_PS=-1
if [[ -n "$secs" && "$secs" != "0" ]]; then
    delta_R_PS=$[ $delta_R / $secs ]
    delta_W_PS=$[ $delta_W / $secs ]
fi
if [  "$delta_R_PS" -lt -1  ]; then
    delta_R_PS=-2
fi
if [  "$delta_W_PS" -lt -1  ]; then
    delta_W_PS=-2
fi
printf "
   R=%s
   R_last=%s 
   delta_R=%s
   delta_R_PS=%s
   W=%s
   W_last=%s
   delta_W=%s
   delta_W_PS=%s
   d=%s
   d2=%s
   secs=%s
   " $R ${fruits[2]} $delta_R $delta_R_PS $W ${fruits[3]} $delta_W $delta_W_PS "$d" $d2 $secs  

#        0  1  2  3
printf "%s;%s;%s;%s\n" "$d" $d2 $R $W  >> $L2

printf "%s;%s;%s;%s;%s;%s;sect_R_sec;%s;sect_W_sec\n" "$d" $avgg $avgg_u $mdevv $mdevv_u $delta_R_PS $delta_W_PS >> $LH

if [ $(stat -c%s "$LH") -gt $((1 * 1024 * 1024)) ]; then
    mv $LH $LH.old
fi
if [ $(stat -c%s "$L2") -gt $((1 * 1024 * 1024)) ]; then
    mv $L2 $L2.old
fi
