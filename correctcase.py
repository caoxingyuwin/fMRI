import numpy as np
# 因为它总是错代码，所以我填补了txt空缺值在最后为1
# 创建一个50x9的全0矩阵
matrix = np.zeros((50, 9), dtype=int)

# 读取txt文件
file_path = '/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/correct_case.txt'  # 将其替换为你的txt文件路径

# 定义一个函数来处理不规则的行
def loadtxt_fixed(fname, delimiter=None, dtype=float):
    with open(fname, 'r') as f:
        lines = f.readlines()

    data = []
    for line in lines:
        split_line = line.strip().split(delimiter)
        if len(split_line) == 9:
            data.append(list(map(dtype, split_line)))
        else:
            # 如果列数不对，可以在这里进行处理，比如填充缺失的值
            split_line.extend([np.nan] * (9 - len(split_line)))
            data.append(list(map(dtype, split_line)))

    return np.array(data)

# 读取txt文件内容并进行处理
data = loadtxt_fixed(file_path, dtype=float)

# 遍历txt文件中的数据并更新矩阵
for col_index in range(data.shape[1]):
    for row_index in data[:, col_index]:
        # 确保行索引在1到50之间，并且值不是NaN
        if not np.isnan(row_index) and 1 <= row_index <= 50:
            # 将矩阵中的指定位置设为1
            matrix[int(row_index) - 1, col_index] = 1  # 减1是因为Python的索引从0开始

# 打印结果矩阵
print(matrix)

# 保存结果到一个新的txt文件
output_path = '/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correct_error_case/correct_error_matrix.txt'  # 将其替换为你想要保存的输出文件路径
np.savetxt(output_path, matrix, fmt='%d')

print("文件已保存到:", output_path)
