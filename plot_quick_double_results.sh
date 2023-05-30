#!/bin/bash

gmt gmtset PS_MEDIA = a1

outdir="."
indir1="."
indir2="."
dt="10000"
dt2=`echo $dt | awk '{print $1*2}'`
crossdir="."

loginc="0.07"

psfile="./quick_double_results.ps"
echo $psfile

bearingcpt="./bearing4.cpt"

gmt makecpt -T1e-1/1e4/1 -Cgray -Qo -Z -D > power.cpt
gmt makecpt -T1e-7/1e-3/1 -Cgray -Qo -Z -D > rectpower.cpt
gmt makecpt -T1e-1/1e4/1 -Cgray -Qo -Z -D > xpower.cpt
gmt makecpt -T0/1/0.01 -Cplasma -Z -D > cohpower.cpt

infile1="./amphibia_richness_americas.dat"
infile2="./carnivora_richness_americas.dat"

python3.8 wrapper.py $infile1 $infile2


#### plot SIGNAL 1 ####
proj="-JX8c/8c"
xmean=`cat $indir1/xmirror1.mean | head -n1`
minsig=`gmt gmtinfo -C $indir1/signal1.h | awk -v xmean=$xmean '{print ($1+xmean)*1.1}'`
maxsig=`gmt gmtinfo -C $indir1/signal1.h | awk -v xmean=$xmean '{print ($2+xmean)*1.1}'`

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir1/signal1.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/0/${maxsig}"
rgnkm="-R0/$lenkm/0/${maxsig}"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance, km":/a20f10:"Amplitude, spx":WeS -X10c -Y30c -K > $psfile

awk -v dt=$dt -v xmean=$xmean '{print (NR-1)*dt, $1+xmean}' $indir1/signal1.h | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile

echo "a" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot full CWT 1 ####
proj="-JX8c/8cl"

maxperiod=`gmt gmtinfo -C $indir1/scales_orig1.periods | awk '{print $6}'`
minperiod=`gmt gmtinfo -C $indir1/scales_orig1.periods | awk '{print $5}'`
maxwavnum=`gmt gmtinfo -C $indir1/scales_orig1.periods | awk '{print $8}'`
minwavnum=`gmt gmtinfo -C $indir1/scales_orig1.periods | awk '{print $7}'`

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir1/signal1.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

minperiodlog=`echo $minperiod | awk '{printf "%.2f\n", log($1)}'`
maxperiodlog=`echo $maxperiod | awk '{printf "%.2f\n", log($1)}'`
p2=`awk '{if (NR==2) printf "%.2f\n", log($2)}' $indir1/scales_orig1.periods`

rgnlog="-R0/$len/$minperiodlog/$maxperiodlog"
projlog="-JX8c/8c"

rgn="-R0/$len/$minperiod/$maxperiod"
rgnkm="-R0/$lenkm/$minperiod/$maxperiod"

gmt psbasemap $rgnkm $proj -Ba10000f5000:"Distance, km":/a1f3p:"Wavelength, m":WeS -X11c -O -K >> $psfile

awk '{ printf "%4.8f %4.20f %4.8f \n", $2, log($4), $6}' $indir1/file1.txt | gmt blockmean -I${dt2}/${loginc} $rgnlog | gmt surface -I${dt2}/$loginc $rgnlog -Gsurf.grd
gmt grdimage surf.grd $rgnlog $projlog -E300 -Crectpower.cpt -K -O >> $psfile

echo "b" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile
gmt psscale -Dn0.5/1.06+w8c/0.4c+h+e+m+jCM -Crectpower.cpt $rgn $proj -B+l"Rectified Power" -Q -O -K >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot distance-averaged power 1 ####
rgn="-R$minwavnum/$maxwavnum/1e-7/1e0"
rgnwavl="-R${minperiod}/${maxperiod}/1e-7/1e0"

proj='-JX8cl/8cl'
projwavl="-JX-8cl/8cl"

gmt psbasemap $rgn $proj -Ba1f3p:"Wavenumber, m@+-1@+":/a1p:"Rectified power, @~f@~@-r@-":wES -X11c -O -K >> $psfile
gmt psbasemap $rgnwavl $projwavl -Ba1f3p+l"Wavelength, km" -BN -O -K >> $psfile

awk '{printf "%4.40f %4.40f\n", $1, $2}' $indir1/fft1.pow | gmt psxy $rgn $proj -W0.2p,grey -O -K >> $psfile 
awk '{ printf "%4.40f %4.40f\n",  $3, $5 }' $indir1/sumpower1.fp | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile

echo "c" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot SIGNAL 2 ####
proj="-JX8c/8c"
xmean=`cat $indir2/xmirror2.mean | head -n1`
minsig=`gmt gmtinfo -C $indir2/signal2.h | awk -v xmean=$xmean '{print ($1+xmean)*1.1}'`
maxsig=`gmt gmtinfo -C $indir2/signal2.h | awk -v xmean=$xmean '{print ($2+xmean)*1.1}'`

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir2/signal2.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/0/$maxsig"
rgnkm="-R0/$lenkm/0/$maxsig"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance, km":/a100f50:"Amplitude, spx":WeS -X-22c -Y-12c -O -K >> $psfile


awk -v dt=$dt -v xmean=$xmean '{print (NR-1)*dt, $1+xmean}' $indir2/signal2.h | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile

echo "d" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot full CWT 2 ####
proj="-JX8c/8cl"

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir2/signal2.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/$minperiod/$maxperiod"
rgnkm="-R0/$lenkm/$minperiod/$maxperiod"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance, km":/a1f3p:"Wavelength, m":WeS -X11c -O -K >> $psfile

awk '{ printf "%4.8f %4.20f %4.8f \n", $2, log($4), $6}' $indir2/file2.txt | gmt blockmean -I${dt2}/${loginc} $rgnlog | gmt surface -I${dt2}/$loginc $rgnlog -Gsurf.grd
gmt grdimage surf.grd $rgnlog $projlog -E300 -Crectpower.cpt -K -O >> $psfile

#awk -v dt=$dt '{print (NR-1)*dt, $1}' ./coi.h | gmt psxy $rgn $proj -W1.5p,grey -O -K >> $psfile

echo "e" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile
gmt psscale -Dn0.5/1.06+w8c/0.4c+h+e+m+jCM -Crectpower.cpt $rgn $proj -B+l"Rectified Power" -Q -O -K >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot distance-averaged power 2 ####
rgn="-R$minwavnum/$maxwavnum/1e-7/1e0"
rgnwavl="-R${minperiod}/${maxperiod}/1e-7/1e0"

proj='-JX8cl/8cl'
projwavl="-JX-8cl/8cl"

gmt psbasemap $rgn $proj -Ba1f3p:"Wavenumber, m@+-1@+":/a1p:"Rectified power, @~f@~@-r@-":wES -X11c -O -K >> $psfile
gmt psbasemap $rgnwavl $projwavl -Ba1f3p+l"Wavelength, km" -BN -O -K >> $psfile

awk '{printf "%4.40f %4.40f\n", $1, $2}' $indir2/fft2.pow | gmt psxy $rgn $proj -W0.2p,grey -O -K >> $psfile 
awk '{ printf "%4.40f %4.40f\n",  $3, $5 }' $indir2/sumpower2.fp | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile

echo "f" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot full X POWER ####
proj="-JX8c/8cl"

len=`awk -v dt=$dt '{print (NR-1)*dt}' $crossdir/signal1.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/$minperiod/$maxperiod"
rgnkm="-R0/$lenkm/$minperiod/$maxperiod"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance, km":/a1f3p:"Wavelength, m":WeS -X-28.5c -Y-12c -O -K >> $psfile

awk '{ printf "%4.8f %4.20f %4.8f \n", $2, log($4), $3}' $crossdir/file_xw.txt | gmt blockmean -I${dt2}/${loginc} $rgnlog | gmt surface -I${dt2}/$loginc $rgnlog -Gsurf.grd
gmt grdimage surf.grd $rgnlog $projlog -E300 -Cxpower.cpt -K -O >> $psfile

awk '{print $2, $4, $3, "9p"}' $crossdir/phase.txt | awk '$1%250000==0' | sort -n -k1 -k2 | awk 'NR%20==0' | gmt psxy $rgn $proj -Sv0.2c+e -Gorange -W0.5p,orange -O -K >> $psfile #, $3 = cross power phase

#awk -v dt=$dt '{print (NR-1)*dt, $1}' ./coi.h | gmt psxy $rgn $proj -W1.5p,grey -O -K >> $psfile

echo "g" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile
gmt psscale -Dn0.5/1.06+w8c/0.4c+h+e+m+jCM -Cxpower.cpt $rgn $proj -B+l"Cross Power" -Q -O -K >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot distance-averaged X POWER ####
rgn="-R$minwavnum/$maxwavnum/1e-7/1e-1"
rgnwavl="-R${minperiod}/${maxperiod}/1e-7/1e-1"

proj='-JX8cl/8cl'
projwavl="-JX-8cl/8cl"

gmt psbasemap $rgn $proj -Ba1f3p:"Wavenumber, m@+-1@+":/a1p:"Cross power":wES -X9c -O -K >> $psfile
gmt psbasemap $rgnwavl $projwavl -Ba1f3p+l"Wavelength, km" -BN -O -K >> $psfile

awk '{ printf "%4.40f %4.40f\n",  $3, $5 }' $crossdir/sumpower_xw.fp | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile

echo "h" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot full COHERENCE ####
proj="-JX8c/8cl"

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir1/signal1.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/$minperiod/$maxperiod"
rgnkm="-R0/$lenkm/$minperiod/$maxperiod"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance":/a1f3p:"Wavelength, m":WeS -X12.5c -O -K >> $psfile

awk '{ printf "%4.8f %4.20f %4.8f \n", $2, log($4), $3}' $outdir/file_coh.txt | gmt blockmean -I${dt2}/${loginc} $rgnlog | gmt surface -I${dt2}/$loginc $rgnlog -Gsurf.grd
gmt grdimage surf.grd $rgnlog $projlog -E300 -Ccohpower.cpt -K -O >> $psfile

#awk '{print $2, $4, $3, "9p"}' $outdir/R_phase.txt | awk '$1%250000==0' | sort -n -k1 -k2 | awk 'NR%20==0' | gmt psxy $rgn $proj -Sv0.2c+e -Gorange -W0.5p,orange -O -K >> $psfile #, $3 = coherence phase
awk '{print $2, $4, $3, "9p"}' $outdir/phase.txt | awk '$1%250000==0' | sort -n -k1 -k2 | awk 'NR%20==0' | gmt psxy $rgn $proj -Sv0.2c+e -Gorange -W0.5p,orange -O -K >> $psfile #, $3 = coherence phase

echo "i" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile
gmt psscale -Dn0.5/1.06+w8c/0.4c+h+e+m+jCM -Ccohpower.cpt $rgn $proj -Ba0.2f0.1+l"Squared Coherence" -O -K >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot distance-averaged COHERENCE ####
rgn="-R$minwavnum/$maxwavnum/1e-3/1e1"
rgnwavl="-R${minperiod}/${maxperiod}/1e-3/1e1"

proj='-JX8cl/8cl'
projwavl="-JX-8cl/8cl"

gmt psbasemap $rgn $proj -Ba1f3p:"Wavenumber, m@+-1@+":/a1p:"Squared Coherence":wES -X9c -O -K >> $psfile
gmt psbasemap $rgnwavl $projwavl -Ba1f3p+l"Wavelength, km" -BN -O -K >> $psfile

awk '{ printf "%4.40f %4.40f\n",  $3, $1 }' $outdir/sumcoh.fp | gmt psxy $rgn $proj -W2.4p,black -O -K >> $psfile # mean over dist but not rectified

echo "j" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile


#### plot full PHASE ####
proj="-JX8c/8cl"

len=`awk -v dt=$dt '{print (NR-1)*dt}' $indir1/signal1.h | gmt gmtinfo -C | awk '{print $2/8}'`
lenkm=`echo $len | awk '{print $1/1000}'`

rgn="-R0/$len/$minperiod/$maxperiod"
rgnkm="-R0/$lenkm/$minperiod/$maxperiod"

gmt psbasemap $rgnkm $proj -Ba5000f1000:"Distance":/a1f3p:"Wavelength, m":EwS -X10.5c -O -K >> $psfile

awk '{if ($3>=0 && $3<=90) print $2, log($4), 90-$3 ; else if ($3>90 && $3<=180) print $2, log($4), 450-$3 ; else if ($3<0) print $2, log($4), 90-$3}' $outdir/phase.txt | gmt blockmean -I${dt2}/${loginc} $rgnlog | gmt surface -I${dt2}/$loginc $rgnlog -Gsurf.grd
gmt grdimage surf.grd $rgnlog $projlog -E300 -C${bearingcpt} -K -O >> $psfile

echo "k" | gmt pstext $rgn $proj -Gwhite -F+f16p,+cTL -D8p/-8p  -K -O >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile
gmt psscale -Dn0.5/1.06+w8c/0.4c+h+e+m+jCM -C${bearingcpt} $rgn $proj -Ba90f45+l"Bearing" -O -K >> $psfile

gmt psbasemap $rgn $proj -Ba0 -O -K >> $psfile




### finish up ###
gmt psbasemap $rgn $proj -Ba0 -O >> $psfile

#ps2jpg
jpgfile=$(echo $psfile | sed s/"\.ps"/".jpg"/)
convert -density 300 -rotate 90 -quality 100 -trim $psfile $jpgfile

rm $psfile

eog $jpgfile &

