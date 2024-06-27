import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import pearsonr
import numpy as np

# 从TXT文件中读取数据
data_file = '/Volumes/EXTERNAL_US/pre/0927/FC/presCP/fc.txt'
df = pd.read_csv(data_file, sep='\t')

# 初始化相关矩阵和p值矩阵
columns = df.columns
corr_matrix = pd.DataFrame(index=columns, columns=columns)
p_value_matrix = pd.DataFrame(index=columns, columns=columns)

# 计算相关矩阵和p值矩阵
for col1 in columns:
    for col2 in columns:
        if col1 == col2:
            corr_matrix.loc[col1, col2] = 1.0
            p_value_matrix.loc[col1, col2] = 0.0
        else:
            corr, p_value = pearsonr(df[col1], df[col2])
            corr_matrix.loc[col1, col2] = corr
            p_value_matrix.loc[col1, col2] = p_value

# 打印相关矩阵和p值矩阵
print("Correlation Matrix:\n", corr_matrix)
print("P-Value Matrix:\n", p_value_matrix)

# 可视化相关矩阵
plt.figure(figsize=(10, 8))
sns.heatmap(corr_matrix.astype(float), annot=True, cmap='coolwarm', vmin=-1, vmax=1)
plt.title('Correlation Matrix of Brain Regions')
plt.savefig('/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correlation_matrix.png') 
plt.show()


# 可视化p值矩阵
plt.figure(figsize=(10, 8))
sns.heatmap(p_value_matrix.astype(float), annot=True, cmap='viridis_r', vmin=0, vmax=0.05)
plt.title('P-Value Matrix of Brain Regions')
plt.savefig('/Volumes/EXTERNAL_US/pre/0927/FC/presCP/correlation_matrix_P-Value.png') 
plt.show()
