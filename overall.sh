#! /bin/bash 

####################################################################################
# function: Explain to deal with the fMRI data after preprocessing by using AFNI   #
# Platform: All linux based platform                                               #
# Version: 1.0                                                                     #
# Author: CAO XINGYU                                                               #
# Date:2024/8/2                                                                    #
# Contact: xingyucao218@gmail.com                                                  #
# Lab: Hisatsune Lab, UTokyo                                                       #
####################################################################################


#Preprecess fMRI data abbrivivate with rr.nii.gz 

# Optional plus preprocessing steps 
    ## Despiking 
    echo "-------------Despiking---------------"
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        ### Preprecessed fMRI data abbrivivate with rr.nii.gz, Please write your own path and fMRI data file name
        3dDespike -prefix /Your_path/${i}/despiked_rr.nii.gz /Your_path/${i}/rr.nii.gz
    done

    ## Detrend
    echo "-------------Detrend-----------------"
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        ### you can set your own suitable polort number, please read 3dDetrend manual 
        3dDetrend -polort 2 -prefix /Your_path/${i}/Detrend_despiked_rr.nii.gz /Your_path/${i}/despiked_rr.nii.gz/
    done

    ## Make Censor file, it will be used in 3dDeconvolve(first level analysis in AFNI)
    echo "-------Making Censor file------------"
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        ### dfile_rr_GE.txt is generated when you using AFNI to do the motion correction processing
        ### dfile_rr_GE.txt should include six Axis motion parameters
        ### censor motion should set by your own data, normally around 0.2(rest state)~0.3(task).
        ### for more details you can refer https://discuss.afni.nimh.nih.gov/t/how-should-the-censor-motion-parameter-be-set-in-1d-tool-py-and-what-is-a-reasonable-value-for-it/7346 
        ### for my data I increase mice voxel ten fold size during preprocess, so I chose censor motion as 2.
        1d_tool.py -infile /Your_path/${i}/dfile_rr_GE.txt -show_censor_count -censor_prev_TR -censor_motion 2 ${i}
    done



# First level Analysis 
    ##3dDeconvolve
    echo "-----------3dDeconvolve--------------"
    ### Please read the manual of 3dDeconvolve first, and confirm every parameter you should change
    ### You should make stimualtion time file which can suitable for your own experiments.
    ### the form of stimualtion time file also wrote in 3dDeconvolve online.
    ### GAMpw(2,2) is mouse HRF seted by myself, there are several deconvolution models you can choose.
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        3dDeconvolve\
        -jobs 4\
        -input /Your_path/${i}/Detrend_despiked_rr.nii.gz\
        -mask /Your_path/100um_AMBMC_model.nii.gz\
        -num_stimts 7\
        -polort 7\
        -global_times \
        -stim_file 1 /Your_path/${i}/dfile_rr_GE.txt[1] -stim_label 1 roll\
        -stim_file 2 /Your_path/${i}/dfile_rr_GE.txt[2] -stim_label 2 pitch\
        -stim_file 3 /Your_path/${i}/dfile_rr_GE.txt[3] -stim_label 3 yaw\
        -stim_file 4 /Your_path/${i}/dfile_rr_GE.txt[4] -stim_label 4 dS\
        -stim_file 5 /Your_path/${i}/dfile_rr_GE.txt[5] -stim_label 5 dL\
        -stim_file 6 /Your_path/${i}/dfile_rr_GE.txt[6] -stim_label 6 dP\
        -stim_times 7 /Your_path/stimu_time.txt 'GAMpw(2,2)' -stim_label 7 'stimulation_point'\
        -bucket /Your_path/outcome/${i}/firstlevel_bucket.nii.gz \
        -cbucket  /Your_path/outcome/${i}/firstlevel_cbucket.nii.gz \
        -x1D /Your_path/outcome/${i}/firstlevel_x1D.txt\
        -censor /Your_censor_file_path/${i}/${i}_censor.1D\
        -xjpeg /Your_path/outcome/${i}/firstlevel.jpg \
    done



# Second level Analysis
    ## 3dttest
    # Compare with two groups by using T-test, you can also using other statistical methods
    # Please notice to choose the coefficient you are concerned about. Here we emphasize how stimulations cause differences between the two groups.
    echo "-----------3dttest--------------"
    3dttest++ -prefix /Your_path/outcome/group_ttest.nii.gz \
    -setA ./A1/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./A5/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./D5/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' \
    -labelA GroupA_name \
    -setB ./A4/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./B1/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]'  ./B2/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./C1/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./C2/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' ./D3/firstlevel_bucket.nii.gz'[stimulation_point#0_Coef]' \
    -labelB GroupB_name


# BOLD signal change rate


    ## segmentation ROI if you need
    ### Befor segment you can use MRIcroGL or Matlab to confirm the coordinates you want to divide. 
    #### here we divide hippocampus to two part base on Z-axis above part and below part.
    
    echo "-----ROI segamentation---------"
    3dZcutup -prefix ROI_cut.nii.gz -keep 14 34 /YOUR_PATH/100um_AMBMC_hippocampus.nii.gz
    3dresample -prefix ROI_cut_reslize.nii.gz -dxyz 1 1 1 -master /YOUR_PATH/100um_AMBMC_hippocampus.nii.gz -inset ROI_cut.nii.gz
    
    
    ## extract BOLD signal from after-smooth .nii file
    echo "-----extract BOLD signal--------"
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        3dmaskave -quiet -mask /Your_path/ROI.nii.gz ${i}.nii.gz > ${i}_BOLD_signal.1D
    done

    ## Deconvolve BOLD signal with models
    ### Please note BOLD_signal.1D should be transposed, as one row!!!  
    ### "resp.A1.stimulation-point" is the final outcome. It will get the average of your BOLD signal data, which is deconvolved by HRF model
    ###  Here I still use the model of GAMpw.
    ### An other lab's member told me they use TENTzero model,for example:'TENTzero(2,20,19)'. 
    ### Also since they have sveral stimulation, so they design the regression model by using several -stim_times in order to differ different conditions
    echo "------BOLD signal deconvolution--------"
    mice=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
    for i in "${mice[@]}";do
        3dDeconvolve\
            -jobs 4\
            -input /Your_path/${i}/${i}_BOLD_signal.1D\
            -num_stimts 7\
            -polort A\
            -global_times \
            -stim_file 1 /Your_path/${i}/dfile_rr_GE.txt[1] -stim_label 1 roll\
            -stim_file 2 /Your_path/${i}/dfile_rr_GE.txt[2] -stim_label 2 pitch\
            -stim_file 3 /Your_path/${i}/dfile_rr_GE.txt[3] -stim_label 3 yaw\
            -stim_file 4 /Your_path/${i}/dfile_rr_GE.txt[4] -stim_label 4 dS\
            -stim_file 5 /Your_path/${i}/dfile_rr_GE.txt[5] -stim_label 5 dL\
            -stim_file 6 /Your_path/${i}/dfile_rr_GE.txt[6] -stim_label 6 dP\
            -stim_times 7 /Your_path/stimu_time.txt'GAMpw(2,2)' -stim_label 7 'stimulation_point' \
            -bucket /Your_path/${i}/${i}_BOLD_stat\
            -nobout -fout -tout \
            -iresp 1 resp.A1.roll \
            -iresp 2 resp.A1.pitch \
            -iresp 3 resp.A1.yaw \
            -iresp 4 resp.A1.ds \
            -iresp 5 resp.A1.dL \
            -iresp 6 resp.A1.dP \
            -iresp 7 resp.A1.stimulation-point \
    done
     
    
    ## BOLD signal change rate with massive averaing and model-free analysis
    ### Please refer paper below 
    ### Whole-brain, time-locked activation with simple tasks revealed using massive averaging and model-free analysis
    ### After extract BOLD signal, we choose txt format to save the BOLD signal data
    3dmaskave -quiet -mask /Your_path/ROI.nii.gz ${i}.nii.gz > ${i}_BOLD_signal.txt
    ### We use python and shell to calculate and massive averaing of BOLD singal change rate, below is the steps.
    #### 1. Make the censor matrix files(comebine all mice' censor file into one file with different columns)
    #### 2. Censor the BOLD signal files.
    #### 3. calculate the BOLD change rate, basline as last 4 seconds. 
    #### 4. Average the BOLDchange rate for all runs.
    #### To executive step 2-4, I wrote the python and shell scripts, Please change the path and filenames in these scripts.
    
    echo "------BOLD signal censoring--------"
    source /your_path/censor.sh

    echo "------BOLD signal calculation--------"
    source /you_path/cal.sh 
