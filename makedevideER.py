# 读取 wholetrail.txt 中的 trail 信息
with open('/Volumes/EXTERNAL_US/pre/0927/241020/wholetrial_C1.txt', 'r') as whole_file:
    trails = whole_file.readline().strip().split(',')

# 定义你的老鼠名称列表
# mice = ['A1', 'A4', 'A5', 'B1', 'B2', 'C2', 'D3', 'D5']
mice = ['C1']
# 对每只老鼠分别处理
for mouse in mice:
    # 读取每只老鼠的 txt 文件 (例如 A1.txt)
    with open(f'/Volumes/EXTERNAL_US/pre/0927/241020/{mouse}.txt', 'r') as file:
        results = [int(line.strip()) for line in file.readlines()]
    
    # 分别收集成功和失败的 trails
    successful_trails = [trails[i] for i in range(45) if results[i] == 1]
    failed_trails = [trails[i] for i in range(45) if results[i] == 0]
    
    # 写入成功和失败的 trail 到新文件
    with open(f'/Volumes/EXTERNAL_US/pre/0927/241020/{mouse}_correct.txt', 'w') as success_file:
        success_file.write(','.join(successful_trails))
    
    with open(f'/Volumes/EXTERNAL_US/pre/0927/241020/{mouse}_error.txt', 'w') as failure_file:
        failure_file.write(','.join(failed_trails))
