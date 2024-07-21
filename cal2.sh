#!/bin/sh

# 设置主目录
base_dir="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold"
# 设置Python脚本路径
python_script="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold/calculate2.py"  # 替换为实际路径

# 定义文件夹数组
folders=("Amygdala" "CCFv3.SSp" "ENTl")

# 遍历每个子目录
for folder in "${folders[@]}"
do
    input_file="$base_dir/$folder/${folder}_combined_censor.txt"
    
    if [ -f "$input_file" ]; then
        echo "Processing $input_file..."
        
        # 构建9个输出文件路径
        output_files=""
        for i in $(seq 1 9); do
            output_file="$base_dir/$folder/mouse_${i}_ratios.txt"
            output_files="$output_files $output_file"
            # 删除已有的同名文件
            if [ -f "$output_file" ]; then
                rm "$output_file"
            fi
        done
        
        # 调用Python脚本
        python3 "$python_script" "$input_file" $output_files
    else
        echo "Input file $input_file not found in folder $folder!"
    fi
done
