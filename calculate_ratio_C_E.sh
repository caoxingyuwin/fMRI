#!/bin/sh

# 设置主目录
base_dir="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold"
# 设置Python脚本路径
python_script="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/calculate_ratio_C_E.py"  # 替换为实际路径
# 设置矩阵文件路径
matrix_file="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/correct_error_matrix.txt"  # 替换为实际路径
# 定义文件夹数组
# folders=("ACB")
folders=("Amygdala" "CCFv3.SSp" "ENTl" "hippocampus" "Hypothalamus" "VTA" "ACB")

# 遍历每个子目录
for folder in "${folders[@]}"
do
    input_file="$base_dir/$folder/${folder}_combined_censor.txt"
    output_file_correct="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/$folder/${folder}_combined_correct_ratio.txt"
    output_file_error="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/$folder/${folder}_combined_error_ratio.txt"
    
    if [ -f "$input_file" ]; then
        echo "Processing $input_file..."
        python3 "$python_script" "$input_file" "$output_file_correct" "$output_file_error" "$matrix_file"
    else
        echo "Input file $input_file not found in folder $folder!"
    fi
done
