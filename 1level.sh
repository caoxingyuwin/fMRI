#!/bin/sh

# 正确地定义数组
list=(A1 A4 A5 B1 B2 C1 C2 D3 D5)

# 使用for循环遍历数组
for i in "${list[@]}"; do
    3dDeconvolve \
    -jobs 4 \
    -input "/Volumes/EXTERNAL_US/pre/0927/allpre/detrended_despike_${i}.nii.gz" \
    -mask "/Volumes/EXTERNAL_US/fmri/100um_AMBMC/100um_AMBMC_model.nii.gz" \
    -num_stimts 7 \
    -polort 7 \
    -global_times \
    -stim_file 1 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[1]" -stim_label 1 roll \
    -stim_file 2 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[2]" -stim_label 2 pitch \
    -stim_file 3 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[3]" -stim_label 3 yaw \
    -stim_file 4 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[4]" -stim_label 4 dS \
    -stim_file 5 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[5]" -stim_label 5 dL \
    -stim_file 6 "/Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/${i}/dfile_rr_GE.txt[6]" -stim_label 6 dP \
    -stim_times 7 "/Volumes/EXTERNAL_US/pre/0927/allpre/stimu_time.1D" 'GAMpw(2,2)' -stim_label 7 'stimulation_point' \
    -bucket "/Volumes/EXTERNAL_US/pre/0927/allpre/${i}/${i}_bucket.nii.gz" \
    -cbucket "/Volumes/EXTERNAL_US/pre/0927/allpre/${i}/${i}_cbucket.nii.gz" \
    -x1D "/Volumes/EXTERNAL_US/pre/0927/allpre/${i}/${i}_GE_x1D.txt" \
    -censor "/Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/censor/0927/${i}/${i}_censor.1D" \
    -xjpeg "/Volumes/EXTERNAL_US/pre/0927/allpre/${i}/${i}/test.jpg"
done



