import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
source_code_dir = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_contracts'))
formatted_code_dir = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_contracts_formatted'))

def format_function_signature(code):
    # 使用正则表达式匹配多行函数签名
    pattern = re.compile(r'function\s+\w+\s*\([^)]*\)\s*.*?{', re.DOTALL)
    
    def replacer(match):
        # 将匹配的多行函数签名转换为单行
        single_line_signature = match.group(0).replace('\n', ' ').replace('  ', ' ')
        # 去掉多余的空格
        single_line_signature = re.sub(r'\s+', ' ', single_line_signature)
        return single_line_signature
    
    formatted_code = re.sub(pattern, replacer, code)
    return formatted_code

def main():
    if not os.path.exists(formatted_code_dir):
        os.makedirs(formatted_code_dir)
    
    for filename in os.listdir(source_code_dir):
        if filename.endswith(".sol"):
            file_path = os.path.join(source_code_dir, filename)
            with open(file_path, 'r', encoding='utf-8') as file:
                code = file.read()
                formatted_code = format_function_signature(code)
                
                # 写入新的格式化文件
                formatted_file_path = os.path.join(formatted_code_dir, filename)
                with open(formatted_file_path, 'w', encoding='utf-8') as formatted_file:
                    formatted_file.write(formatted_code)
    
    print("所有文件已经处理并保存到 sourcecode_contracts_formatted 文件夹中。")

if __name__ == "__main__":
    main()