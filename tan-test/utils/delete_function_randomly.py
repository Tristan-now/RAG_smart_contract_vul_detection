import os
import random

# 定义目标文件夹
script_dir = os.path.dirname(os.path.abspath(__file__))
target_folder = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_functions_0'))

# 获取文件夹中所有文件的列表
files = [os.path.join(target_folder, f) for f in os.listdir(target_folder) if os.path.isfile(os.path.join(target_folder, f))]
print(f"Found {len(files)} files.")
print(files[0])

# 检查文件数量是否超过 500
if len(files) > 500:
    # 计算需要删除的文件数量
    num_files_to_delete = len(files) - 500
    
    # 随机选择要删除的文件
    files_to_delete = random.sample(files, num_files_to_delete)
    
    # 删除选中的文件
    for file_path in files_to_delete:
        os.remove(file_path)

    print(f"Deleted {num_files_to_delete} files. {len(files) - num_files_to_delete} files remaining.")
else:
    print(f"File count is already {len(files)} or less. No files deleted.")
