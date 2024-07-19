import os
import re

script_dir = os.path.dirname(os.path.abspath(__file__))
formatted_code_dir = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_contracts_0'))
output_dir = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_functions_0'))

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

def find_matching_bracket(code, start_index):
    stack = 0
    for index in range(start_index, len(code)):
        if code[index] == '{':
            stack += 1
        elif code[index] == '}':
            stack -= 1
            if stack == 0:
                return index
    return -1

def extract_functions(code):
    # 正则表达式匹配函数签名
    pattern = re.compile(r'function\s+\w+\s*\([^)]*\)\s*.*?{', re.DOTALL)
    matches = pattern.finditer(code)
    functions = []
    
    for match in matches:
        start = match.start()
        end = find_matching_bracket(code, match.end() - 1)
        if end != -1:
            functions.append(code[start:end + 1])
    
    return functions

def main():
    for filename in os.listdir(formatted_code_dir):
        if filename.endswith(".sol"):
            file_path = os.path.join(formatted_code_dir, filename)
            with open(file_path, 'r', encoding='utf-8') as file:
                code = file.read()
                functions = extract_functions(code)
                
                for function in functions:
                    # 提取函数名
                    function_name = re.search(r'function\s+(\w+)', function).group(1)
                    # 创建一个新的文件名，例如：original_filename_functionName.sol
                    new_filename = f"{os.path.splitext(filename)[0]}_{function_name}.sol"
                    new_file_path = os.path.join(output_dir, new_filename)
                    
                    with open(new_file_path, 'w', encoding='utf-8') as output_file:
                        output_file.write(function)
    
    print("所有函数已经提取并保存到 sourcecode_functions 文件夹中。")

if __name__ == "__main__":
    main()