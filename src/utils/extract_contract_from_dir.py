import os
import shutil

# 定义源文件夹和目标文件夹
script_dir = os.path.dirname(os.path.abspath(__file__))
source_folder = os.path.abspath(os.path.join(script_dir, '..', 'contracts_0'))
destination_folder = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_contracts_0'))

if not os.path.exists(destination_folder):
    os.makedirs(destination_folder)

exclude_keywords = ['interface', 'mock', 'external', 'test', 'testing', 'zeppelin', 'ERC', 'IERC']

# 递归遍历源文件夹
for root, dirs, files in os.walk(source_folder):
    dirs[:] = [d for d in dirs if not any(keyword in d.lower() for keyword in exclude_keywords)]
    for file in files:
        if file.endswith('.sol') and not any(keyword in file for keyword in exclude_keywords):
            full_file_path = os.path.join(root, file)
            parent_folder_name = os.path.basename(os.path.dirname(full_file_path))
            new_file_name = f'{parent_folder_name}_{file}'
            destination_file_path = os.path.join(destination_folder, new_file_name)
            shutil.copy2(full_file_path, destination_file_path)
print("文件复制和重命名完成。")
