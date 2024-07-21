import numpy as np
import pandas as pd
import sys

def calculate_ratios(file_path, output_paths):
    # 读取TXT文件，假设每列代表一只老鼠，每行代表一个时间点
    data = pd.read_csv(file_path, sep='\t', header=None)

    # 获取老鼠数量和时间点数量
    num_mice, num_timepoints = data.shape[1], data.shape[0]

    # 确保只有9只老鼠的数据
    assert num_mice == 9, f"Expected 9 mice data, but got {num_mice}"

    # 定义每轮的时间点数
    points_per_round = 20

    # 特殊处理第六只老鼠的数据轮数
    num_rounds_list = [45 if i == 5 else num_timepoints // points_per_round for i in range(num_mice)]

    # 计算变化率并保存每只老鼠的结果
    for mouse_idx in range(num_mice):
        mouse_data = data.iloc[:, mouse_idx].values
        num_rounds = num_rounds_list[mouse_idx]
        round_ratios = []

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
                    round_ratios.append(ratio)
            else:
                ratio = np.zeros(points_per_round)
                round_ratios.append(ratio)

        # 将每只老鼠的变化率矩阵保存到文件
        pd.DataFrame(round_ratios).to_csv(output_paths[mouse_idx], sep='\t', index=False)

if __name__ == "__main__":
    if len(sys.argv) != 11:  # 1个输入文件和9个输出文件
        print("Usage: python script.py input_file output_file1 output_file2 ... output_file9")
    else:
        input_file = sys.argv[1]
        output_files = sys.argv[2:]
        calculate_ratios(input_file, output_files)
