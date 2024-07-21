
#!/bin/sh

# 设置主目录
base_dir="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold"
# 设置Python脚本路径
python_script="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/bold/calculate2_C_E.py"  # 替换为实际路径
# 设置矩阵文件路径
matrix_file="/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/correct_error_matrix.txt"  # 替换为实际路径
# 定义文件夹数组
folders=("Amygdala" "CCFv3.SSp" "ENTl")

# 遍历每个子目录
for folder in "${folders[@]}"
do
    input_file="$base_dir/$folder/${folder}_combined_censor.txt"

    if [ -f "$input_file" ]; then
        echo "Processing $input_file..."
        
        # 构建9个输出文件路径
        output_files_correct=""
        output_files_error=""
        for i in $(seq 1 9); do
            output_file_correct="$base_dir/$folder/correctcase/mouse_${i}_ratios_correct.txt"
            output_file_error="$base_dir/$folder/errorcase/mouse_${i}_ratios_error.txt"
            output_files_correct="$output_files_correct $output_file_correct"
            output_files_error="$output_files_error $output_file_error"
            # 删除已有的同名文件
            if [ -f "$output_file_correct" ]; then
                rm "$output_file_correct"
            fi
            if [ -f "$output_file_error" ]; then
                rm "$output_file_error"
            fi
        done
        
        # 调用Python脚本
        python3 "$python_script" "$input_file" $output_files_correct $output_files_error "$matrix_file"
    else
        echo "Input file $input_file not found in folder $folder!"
    fi
done
