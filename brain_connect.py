import numpy as np
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

# 读取相关性矩阵
fc_matrix = pd.read_csv('/Volumes/EXTERNAL_US/pre/0927/FC/presCP/fcmatrix.txt', sep='\t', index_col=0)

# 读取p值矩阵
p_matrix = pd.read_csv('/Volumes/EXTERNAL_US/pre/0927/FC/presCP/fcmatrix_pvalue.txt', sep='\t', index_col=0)

# 创建无向图
G = nx.Graph()

# 添加节点
nodes = fc_matrix.index.tolist()
G.add_nodes_from(nodes)

# 添加边和权重，根据p值筛选显著连接
threshold = 0.05  # 设定显著性水平
for i, region1 in enumerate(nodes):
    for j, region2 in enumerate(nodes):
        if i < j:  # 确保每对只添加一次
            correlation = fc_matrix.loc[region1, region2]
            p_value = p_matrix.loc[region1, region2]
            if p_value < threshold:
                G.add_edge(region1, region2, weight=correlation)

# 位置布局
pos = nx.spring_layout(G)

# 画图
plt.figure(figsize=(10, 8))

# 绘制节点
nx.draw_networkx_nodes(G, pos, node_size=700, node_color='skyblue')

# 绘制边并根据权重设置透明度
edges = G.edges(data=True)
weights = [d['weight'] for (u, v, d) in edges]
nx.draw_networkx_edges(G, pos, edgelist=edges, width=2, edge_color=weights, edge_cmap=plt.cm.viridis)

# 添加标签
nx.draw_networkx_labels(G, pos, font_size=12)

# 显示图
plt.title('Functional Connectivity Graph with Significant Correlations')
plt.show()
