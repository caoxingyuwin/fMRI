mice=("A1" "A4" "A5" "B1" "B2" "C1" "C2" "D3" "D5")
for i in "${mice[@]}"; do
    # 读取数据文件中的内容
    data=$(cat "/Volumes/EXTERNAL_US/pre/0927/241020/${i}_error.txt")

    # 使用 3dTcat 命令
    3dTcat -prefix "/Volumes/EXTERNAL_US/pre/0927/241020/${i}/${i}_error.nii.gz" "/Volumes/EXTERNAL_US/pre/0927/allpre/detrended_despike_${i}.nii.gz[${data}]"
done
