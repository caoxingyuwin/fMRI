with open('/Volumes/EXTERNAL_US/pre/0927/241020/wholetrial.txt', 'w') as file:
    # 生成每个 trail 的范围
    trails = [f"{i*20}..{i*20+19}" for i in range(50)]
    
    # 将所有 trail 合并成一行，用逗号分隔
    file.write(','.join(trails))
  