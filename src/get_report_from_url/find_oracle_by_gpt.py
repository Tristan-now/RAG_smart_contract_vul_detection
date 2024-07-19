import requests
import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

script_dir = os.path.dirname(os.path.abspath(__file__))
api_key_path = os.path.join(script_dir, '..','utils','api_key.txt')

vul_dir = os.path.abspath(os.path.join(script_dir, 'reports_vuls_oracle'))
oracle_vul_dir = os.path.abspath(os.path.join(script_dir, 'reports_vuls_oracle_2'))

def get_api_key():
    try:
        with open(api_key_path, 'r') as file:
            api_key = file.read().strip()
    except FileNotFoundError:
        print(f"File not found: {api_key_path}")
        return None
    return api_key

def ask_chatgpt(api_key, question):
    url = "https://api.openai.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }
    data = {
        "model": "gpt-3.5-turbo-0125",
        "messages": [
            {"role": "user", "content": question}
        ],
        "temperature": 0.7,
    }

    while True:
        try:
            time.sleep(2)
            response = requests.post(url, json=data, headers=headers)
            if response.status_code == 200:
                return response.json()
            elif response.status_code == 429:
                error_message = response.json()
                print(f"Rate limit error: {error_message['error']['message']}")
                retry_after = int(error_message.get('error', {}).get('param', 1))
                print(f"Retrying after {retry_after} seconds...")
                time.sleep(retry_after)
            else:
                print(f"Error: API request failed with status code {response.status_code}")
                print(f"Response: {response.text}")
                return None
        except ValueError as ve:
            print(f"ValueError: {ve}")
            continue
        except TypeError as te:
            print(f"TypeError: {te}")
            continue
        except requests.exceptions.RequestException as re:
            print(f"RequestException: {re}")
            continue
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            continue

def process_file(api_key, filename):
    file_path = os.path.join(vul_dir, filename)
    with open(file_path, 'r', encoding='utf-8') as file:
        code = file.read()
        question_head = """
        Is the potential attack described in the following vulnerability report classified as a AMM/Non-AMM price oracle manipulation or a sandwich attack? Please answer with either “yes” or “no” only. Simulate answering five times in the background and select the most frequently occurring answer. Note, only output the most frequent answer once, and do not output any other content.

        """
        question = question_head + code
        response = ask_chatgpt(api_key, question)
        
        if response is None:
            return f"Error processing {filename}: API request failed."

        try:
            reply = response['choices'][0]['message']['content']
        except KeyError:
            print(f"Error processing {filename}: 'choices' not found in response.")
            print(f"Response content: {json.dumps(response, indent=2)}")
            return f"Error processing {filename}"
        
        if reply.lower() == "yes":
            with open(os.path.join(oracle_vul_dir, filename), 'w', encoding='utf-8') as new_file:
                new_file.write(code)
    return f"Processed {filename}"

def main():
    api_key = get_api_key()
    if not api_key:
        return
    if not os.path.exists(oracle_vul_dir):
        os.makedirs(oracle_vul_dir)
    
    txt_files = [f for f in os.listdir(vul_dir) if f.endswith(".txt")]

    # 使用tqdm显示进度条
    total_files = len(txt_files)
    progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

    with ThreadPoolExecutor(max_workers=2) as executor:
        futures = [executor.submit(process_file, api_key, filename) for filename in txt_files]
        for future in as_completed(futures):
            result = future.result()
            # print(result)
            progress_bar.update(1)
    
    progress_bar.close()
    print("所有文件已经处理并保存到 reports_vuls_oracle 文件夹中。")

if __name__ == "__main__":
    main()