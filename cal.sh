#!/bin/sh

# 设置主目录
base_dir="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold"
# 设置Python脚本路径
python_script="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold/calculate_ratios.py"  # 替换为实际路径

# 定义文件夹数组
folders=("ACB")
# folders=("Amygdala" "CCFv3.SSp" "ENTl" "hippocampus" "Hypothalamus" "VTA")

# 遍历每个子目录
for folder in "${folders[@]}"
do
    input_file="$base_dir/$folder/${folder}_combined_censor.txt"
    output_file="$base_dir/$folder/${folder}_combined_ratio.txt"
    process_path="$base_dir/$folder"
    
    if [ -f "$input_file" ]; then
        echo "Processing $input_file..."
        python3 "$python_script" "$input_file" "$output_file" "$process_path"
    else
        echo "Input file $input_file not found in folder $folder!"
    fi
done






