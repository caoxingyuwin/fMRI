import numpy as np
import pandas as pd
import sys

def calculate_ratios(file_path, output_paths_correct, output_paths_error, matrix_path):
    # 读取BOLD信号数据，假设每列代表一只老鼠，每行代表一个时间点
    data = pd.read_csv(file_path, sep='\t', header=None)

    # 读取50x9的矩阵文件
    matrix = pd.read_csv(matrix_path, sep=' ', header=None).values

    # 获取老鼠数量和时间点数量
    num_mice, num_timepoints = data.shape[1], data.shape[0]

    # 确保只有9只老鼠的数据
    assert num_mice == 9, f"Expected 9 mice data, but got {num_mice}"

    # 定义每轮的时间点数
    points_per_round = 20

    # 特殊处理第六只老鼠的数据轮数
    num_rounds_list = [45 if i == 5 else num_timepoints // points_per_round for i in range(num_mice)]

    # 初始化存储平均变化率的列表
    average_ratios_correct = np.zeros((points_per_round, num_mice))
    average_ratios_error = np.zeros((points_per_round, num_mice))

    # 存储每只老鼠的变化率矩阵
    mouse_ratios_matrices = []

    # 计算变化率并平均
    for mouse_idx in range(num_mice):
        mouse_data = data.iloc[:, mouse_idx].values
        num_rounds = num_rounds_list[mouse_idx]
        round_ratios_correct = []
        round_ratios_error = []

        for round_idx in range(num_rounds):
            start = round_idx * points_per_round
            end = start + points_per_round

            # 获取最后4个时间点的值
            last_four = mouse_data[end - 4:end]

            # 检查最后4个时间点中是否至少有一个非零非空值
            if not np.all(last_four == 0) and not np.all(np.isnan(last_four)):
                # 计算基线，忽略0和空值
                valid_last_four = last_four[(last_four != 0) & (~np.isnan(last_four))]
                if len(valid_last_four) > 0:
                    baseline = np.mean(valid_last_four)
                    ratio = mouse_data[start:end] / baseline
                    if matrix[round_idx, mouse_idx] == 1:
                        round_ratios_correct.append(ratio)
                    else:
                        round_ratios_error.append(ratio)
            else:
                ratio = np.zeros(points_per_round)
                if matrix[round_idx, mouse_idx] == 1:
                    round_ratios_correct.append(ratio)
                else:
                    round_ratios_error.append(ratio)

        # 将每只老鼠的变化率矩阵保存到文件
        pd.DataFrame(round_ratios_correct).to_csv(output_paths_correct[mouse_idx], sep='\t', index=False)
        pd.DataFrame(round_ratios_error).to_csv(output_paths_error[mouse_idx], sep='\t', index=False)

if __name__ == "__main__":
    if len(sys.argv) != 21:  # 1个输入文件，9个正确输出文件，9个错误输出文件，1个矩阵文件
        print("Usage: python script.py input_file output_file_correct1 output_file_correct2 ... output_file_correct9 output_file_error1 output_file_error2 ... output_file_error9 matrix_file")
    else:
        input_file = sys.argv[1]
        output_files_correct = sys.argv[2:11]
        output_files_error = sys.argv[11:20]
        matrix_file = sys.argv[20]
        calculate_ratios(input_file, output_files_correct, output_files_error, matrix_file)
