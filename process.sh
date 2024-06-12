
#3dDespike
3dDespike -prefix despike_output.nii.gz input_fmri_data.nii.gz
3dDespike -prefix /Volumes/EXTERNAL_US/pre/pres_despike/A1/NOs_despike_A1.nii.gz rrmrrr_GE.nii.gz



#!/bin/sh

# 正确地定义数组
line=(A1 A4 A5 B1 B2 C1 C3 D3 D5)

# 使用正确的for循环语法
for i in "${line[@]}"; do
    3dDespike -prefix "despike_${i}.nii.gz" "/Volumes/EXTERNAL_US/pre/0927/smooth/${i}/smrrmrrr_GE.nii.gz"
done

:'
3dDespike -prefix despike_A4.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/A4/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_A5.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/A5/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_B1.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/B1/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_B2.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/B2/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_C1.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/C1/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_C2.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/C2/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_D3.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/D3/smrrmrrr_GE.nii.gz
3dDespike -prefix despike_D5.nii.gz /Volumes/EXTERNAL_US/pre/0927/smooth/D5/smrrmrrr_GE.nii.gz
'

line( A1 A4 A5 B1 B2 C1 C2 D3 D5)
for i in "${line[@]}"
do
    3dDetrend -polort 2 -prefix detrended_despike_${i}.nii.gz despike_${i}.nii.gz
done

3dDetrend -polort 2 -prefix detrended_despike_A1.nii.gz despike_A1.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_A4.nii.gz despike_A4.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_A5.nii.gz despike_A5.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_B1.nii.gz despike_B1.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_B2.nii.gz despike_B2.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_C1.nii.gz despike_C1.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_C2.nii.gz despike_C2.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_D3.nii.gz despike_D3.nii.gz
3dDetrend -polort 2 -prefix detrended_despike_D5.nii.gz despike_D5.nii.gz













# censoring
# 1d_tool.py -infile dfile_rr_GE.txt -demean -write de_mot.txt 这一步应该不需要，不需要demean
1d_tool.py -infile /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A4/dfile_rr_GE.txt -show_censor_count -censor_prev_TR -censor_motion 2 A4


# extract_signal 
3dmaskave -mask /Volumes/EXTERNAL_US/fmri/100um_AMBMC/100um_AMBMC_hippocampus.nii.gz NOs_despike_A1.nii.gz  > A1_1000BOLD.txt

3dDeconvolve\
# perform time series regression modeling.
 -jobs 4\
 -input /Volumes/EXTERNAL_US/pre/0927/smooth/A1/smrrmrrr_GE.nii.gz\
 -mask /Volumes/EXTERNAL_US/fmri/100um_AMBMC/100um_AMBMC_model.nii.gz\
 -num_stimts 7\
 -polort 7\
 -global_times \
 -stim_file 1 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[1] -stim_label 1 roll\
 -stim_file 2 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[2] -stim_label 2 pitch\
 -stim_file 3 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[3] -stim_label 3 yaw\
 -stim_file 4 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[4] -stim_label 4 dS\
 -stim_file 5 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[5] -stim_label 5 dL\
 -stim_file 6 /Volumes/EXTERNAL_US/Lee_re-pre/0927/co_only/A1/dfile_rr_GE.txt[6] -stim_label 6 dP\
 -stim_times 7 /Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/stimu_time.txt 'GAMpw(2,2)' -stim_label 7 'stimulation_point'\
 -bucket /Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/A1/smrrmrrr_GE_bucket.nii.gz\
 -cbucket /Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/A1/smrrmrrr_GE_cbucket.nii.gz\
 -x1D /Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/A1/smrrmrrr_GE_x1D.txt\
 -censor /Volumes/EXTERNAL_US/pre/0927/3dDeconvolve/censor/0927/A1/A1_censor.1D\
 -xjpeg ./A1/test.jpg \
done














3dttest++ -prefix group_ttest.nii.gz \
-setA 'A1_smrrmrrr_GE_bucket.nii.gz'[7]'' 'A5_smrrmrrr_GE_bucket.nii.gz'[7]'' D5_smrrmrrr_GE_bucket.nii.gz'[7]' \
-labelA Goodlearner \
-setB A4_smrrmrrr_GE_bucket.nii.gz'[7]' B1_smrrmrrr_GE_bucket.nii.gz'[7]'  B2_smrrmrrr_GE_bucket.nii.gz'[7]' C1_smrrmrrr_GE_bucket.nii.gz'[7]' C2_smrrmrrr_GE_bucket.nii.gz'[7]' D3_smrrmrrr_GE_bucket.nii.gz'[7]' \
-labelB Badlearner\
-mask 100um_AMBMC_model.nii.gz


3dttest++ -prefix group_ttest.nii.gz \
-setA 'A1_smrrmrrr_GE_bucket.nii.gz'[7]' 'A5_smrrmrrr_GE_bucket.nii.gz[7]' 'D5_smrrmrrr_GE_bucket.nii.gz[7]' \
-labelA Goodlearner \
-setB 'A4_smrrmrrr_GE_bucket.nii.gz'[7]' 'B1_smrrmrrr_GE_bucket.nii.gz[7]' 'B2_smrrmrrr_GE_bucket.nii.gz[7]' 'C1_smrrmrrr_GE_bucket.nii.gz[7]' 'C2_smrrmrrr_GE_bucket.nii.gz[7]' 'D3_smrrmrrr_GE_bucket.nii.gz[7]' \
-labelB Badlearner \
-mask 100um_AMBMC_model.nii.gz








3dttest++ -prefix group_ttest.nii.gz \
-setA A1_smrrmrrr_GE_bucket.nii.gz A5_smrrmrrr_GE_bucket.nii.gz D5_smrrmrrr_GE_bucket.nii.gz \
-labelA Goodlearner \
-setB A4_smrrmrrr_GE_bucket.nii.gz B1_smrrmrrr_GE_bucket.nii.gz  B2_smrrmrrr_GE_bucket.nii.gz C1_smrrmrrr_GE_bucket.nii.gz C2_smrrmrrr_GE_bucket.nii.gz D3_smrrmrrr_GE_bucket.nii.gz \
-labelB Badlearner \
-mask /Volumes/EXTERNAL_US/fmri/100um_AMBMC/100um_AMBMC_model.nii.gz/100um_AMBMC_model.nii.gz

3dttest++ -prefix group_ttest.nii.gz \
-setA A1_con_0001.nii A5_con_0001.nii D5_con_0001.nii \
-labelA Goodlearner \
-setB A4_con_0001.nii B1_con_0001.nii  B2_con_0001.nii C1_con_0001.nii C2_con_0001.nii D3_con_0001.nii \
-labelB Badlearner \




3dttest++ -prefix group_ttest.nii.gz \
-setA ./A1/A1_bucket.nii.gz'[7]' ./A5/A5_bucket.nii.gz'[7]' ./D5/D5_bucket.nii.gz'[7]' \
-labelA Goodlearner \
-setB ./A4/A4_bucket.nii.gz'[7]' ./B1/B1_bucket.nii.gz'[7]'  ./B2/B2_bucket.nii.gz'[7]' ./C1/C1_bucket.nii.gz'[7]' ./C2/C2_bucket.nii.gz'[7]' ./D3/D3_bucket.nii.gz'[7]' \
-labelB Badlearner 





stimulation_point#0_Coef

3dttest++ -prefix stimulation_group_ttest.nii.gz \
-setA ./A1/A1_bucket.nii.gz'[stimulation_point#0_Coef]' ./A5/A5_bucket.nii.gz'[stimulation_point#0_Coef]' ./D5/D5_bucket.nii.gz'[stimulation_point#0_Coef]' \
-labelA Goodlearner \
-setB ./A4/A4_bucket.nii.gz'[stimulation_point#0_Coef]' ./B1/B1_bucket.nii.gz'[stimulation_point#0_Coef]'  ./B2/B2_bucket.nii.gz'[stimulation_point#0_Coef]' ./C1/C1_bucket.nii.gz'[stimulation_point#0_Coef]' ./C2/C2_bucket.nii.gz'[stimulation_point#0_Coef]' ./D3/D3_bucket.nii.gz'[stimulation_point#0_Coef]' \
-labelB Badlearner 

# bad learner 组内分析  他是针对一组和0无激活的对比
3dttest++ -prefix stimulation_goodgroup_ttest.nii.gz \
-setA ./A1/A1_bucket.nii.gz'[stimulation_point#0_Coef]' ./A5/A5_bucket.nii.gz'[stimulation_point#0_Coef]' ./D5/D5_bucket.nii.gz'[stimulation_point#0_Coef]' \

# good learner 组内分析  他是针对一组和0无激活的对比
3dttest++ -prefix stimulation_badgroup_ttest.nii.gz \
-setA ./A4/A4_bucket.nii.gz'[stimulation_point#0_Coef]' ./B1/B1_bucket.nii.gz'[stimulation_point#0_Coef]'  ./B2/B2_bucket.nii.gz'[stimulation_point#0_Coef]' ./C1/C1_bucket.nii.gz'[stimulation_point#0_Coef]' ./C2/C2_bucket.nii.gz'[stimulation_point#0_Coef]' ./D3/D3_bucket.nii.gz'[stimulation_point#0_Coef]' \




合并多个roi
cd /Volumes/EXTERNAL_US/fmri/100um_AMBMC/Rois
3dmask_tool -input roi_ENTl1.nii.gz roi_ENTl2.nii.gz roi_ENTl3.nii.gz roi_ENTl5.nii.gz roi_ENTl6a.nii.gz \
            -union -prefix combined_ENTl.nii
