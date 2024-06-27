#!/bin/bash

# 进入目标目录
cd "/Volumes/EXTERNAL_US/pre/0927/FC/presCP" || exit

# 定义数据集列表
line=(A1 A4 A5 B1 B2 C1 C2 D3 D5)
mask="/Volumes/EXTERNAL_US/pre/0927/FC/ROI/ACB.nii"
# 遍历每个 ROI 掩膜文件
maskname=$(basename "$mask" .nii)
mkdir -p "./bold/${maskname}"
for i in "${line[@]}"; do
    # 使用 3dmaskave 提取 BOLD 信号时间序列
    3dmaskave -mask "$mask" "${i}.nii.gz" > "./bold/${maskname}/BOLDsignal_${maskname}_${i}.txt"
    output="./bold/${maskname}/BOLDsignal_${maskname}_${i}.txt"
    # 使用 awk 去除第二列并保存
    awk '{print $1}' "$output" > "${output}.tmp"
    mv "${output}.tmp" "$output"
done

# 初始化合并文件
output_file="./bold/${maskname}/${maskname}_combined.txt"
> "$output_file"

# 使用 paste 命令合并所有 txt 文件的第一列到 combined 文件中
paste ./bold/${maskname}/BOLDsignal_${maskname}_*.txt > "$output_file"

