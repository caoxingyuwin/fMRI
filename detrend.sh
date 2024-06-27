#!/bin/sh

line=( A1 A4 A5 B1 B2 C1 C2 D3 D5)
for i in "${line[@]}"
do
    3dDetrend -polort 2 -prefix detrended_despike_${i}.nii.gz despike_${i}.nii.gz
done