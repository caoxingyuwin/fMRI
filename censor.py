import pandas as pd
import numpy as np
import sys

def censor(input_file, output_file):
    # 定义censor文件的路径
    censor_file = '/Volumes/EXTERNAL_US/pre/0927/FC/presPD/0927censor_matrix.txt'

    try:
        # 加载数据文件和censor文件
        combined_data = pd.read_csv(input_file, header=None, sep='\t')
        censor = pd.read_csv(censor_file, header=None, sep='\t')

        # 检查数据文件和censor文件的形状是否一致
        if combined_data.shape != censor.shape:
            raise ValueError("Data file and censor file must have the same dimensions.")

        # 处理数据
        processed_data = combined_data * np.where(censor.notnull(), censor, 1)

        # 保存处理后的数据到文件
        processed_data.to_csv(output_file, index=False, header=False, sep='\t')

        print(f"保存处理后的数据到 {output_file}")
        print("处理完成。")

    except pd.errors.ParserError:
        print("Error: Failed to parse data file or censor file.")
        raise
    except ValueError as ve:
        print(ve)

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    censor(input_file, output_file)
