# 定义老鼠名称列表
mice = ['A1', 'A4', 'A5', 'B1', 'B2', 'C2', 'D3', 'D5']
# mice = ['C1']
# 循环处理每只老鼠的文件
for mouse in mice:
    # 读取成功和失败的 trail 数据
    with open(f'/Volumes/EXTERNAL_US/pre/0927/241020/{mouse}.txt', 'r') as results_file:
        results = [int(line.strip()) for line in results_file.readlines()]

    # 读取 censor 文件
    with open(f'/Volumes/EXTERNAL_US/pre/0927/3dDeconvolve_smrr/censor/0927/{mouse}/{mouse}_censor.1D', 'r') as censor_file:
        censor_data = [line.strip() for line in censor_file.readlines()]

    # 分离成功和失败的 censor 数据
    correct_censor = []
    error_censor = []

    for i in range(50):  # 50个 trails
        if results[i] == 1:  # 成功
            correct_censor.extend(censor_data[i * 20:(i + 1) * 20])  # 20 秒
        else:  # 失败
            error_censor.extend(censor_data[i * 20:(i + 1) * 20])  # 20 秒

    # 写入成功的 censor 数据到新文件
    with open(f'/Volumes/EXTERNAL_US/pre/0927/3dDeconvolve_smrr/censor/0927/{mouse}/{mouse}_correct.1D', 'w') as success_file:
        success_file.write('\n'.join(correct_censor))

    # 写入失败的 censor 数据到新文件
    with open(f'/Volumes/EXTERNAL_US/pre/0927/3dDeconvolve_smrr/censor/0927/{mouse}/{mouse}_error.1D', 'w') as failure_file:
        failure_file.write('\n'.join(error_censor))
