import requests
import os
import json
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

script_dir = os.path.dirname(os.path.abspath(__file__))
api_key_path = os.path.join(script_dir, 'api_key.txt')
source_code_dir = os.path.abspath(os.path.join(script_dir, '..', 'sourcecode_functions_0'))
commented_code_dir = os.path.abspath(os.path.join(script_dir, '..', 'functions_desc_0'))

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
        "temperature": 0
    }

    while True:
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

def process_file(api_key, filename):
    file_path = os.path.join(source_code_dir, filename)
    with open(file_path, 'r', encoding='utf-8') as file:
        code = file.read()
        question_head = """
        You are a smart contract development expert.
        Please explain the working process of the following code in detail, as thoroughly as possible. 
        For example, you need to do the following:
        The code I am giving you:
        function sumTokensInPeg(
            address[] storage tokens,
            mapping(address => uint256) storage amounts,
            bool forceCurBlock
        ) internal returns (uint256 totalPeg) {
            uint256 len = tokens.length;
            for (uint256 tokenId; tokenId < len; tokenId++) {
                address token = tokens[tokenId];
                totalPeg += PriceAware.getCurrentPriceInPeg(
                    token,
                    amounts[token],
                    forceCurBlock
                );
            }
        }
        You need to answer like this：
        This code defines an internal function named `sumTokensInPeg`, which calculates the total value of a collection of tokens. The function accepts three parameters: an array of addresses (`tokens`), a mapping of amounts (`amounts`), and a boolean (`forceCurBlock`). Here’s a detailed explanation of how this function works:

        Parameters:
        1. `tokens`: An array of addresses that stores the addresses of multiple tokens.
        2. `amounts`: A mapping where the key is the token address and the value is the corresponding token amount.
        3. `forceCurBlock`: A boolean that indicates whether to force the use of the current block.

        Return Value:
        `totalPeg`: The function returns a `uint256` value representing the sum of the total values of all tokens.

        Code Breakdown:
        The function signature includes the parameters `tokens`, `amounts`, and `forceCurBlock`. `sumTokensInPeg` is an internal function, meaning it can only be called within the contract or its derived contracts. The function accepts three parameters: `tokens` (an array of token addresses), `amounts` (a mapping of token amounts), and `forceCurBlock` (a boolean value). The function returns a `uint256` variable named `totalPeg`, initialized to 0. This variable will store the total value of all tokens. The variable `len` stores the length of the `tokens` array, which is used to control the number of iterations in the loop. A `for` loop is used to iterate over the `tokens` array. The loop starts with `tokenId` initialized to 0 and runs until `tokenId` is less than `len`, incrementing `tokenId` by 1 each iteration. In each iteration, the current token address is obtained using `tokens[tokenId]` and stored in the variable `token`. For each token, the `PriceAware.getCurrentPriceInPeg` function is called. This function requires three parameters: the token address `token`, the token amount `amounts[token]`, and the boolean `forceCurBlock`. The result of this function call (the current price of the token in peg units) is added to the `totalPeg` variable.

        Summary:
        The `sumTokensInPeg` function iterates over a given array of token addresses (`tokens`), retrieves the corresponding token amount from the `amounts` mapping, and calls the `PriceAware.getCurrentPriceInPeg` function to get the current price of each token in peg units. It then sums these prices to calculate the total value of all tokens in peg units and returns this total value.

        """
        question = question_head + f"\n\n please do the job according to the code follows: {code}"
        response = ask_chatgpt(api_key, question)
        
        if response is None:
            return f"Error processing {filename}: API request failed."

        try:
            reply = response['choices'][0]['message']['content']
        except KeyError:
            print(f"Error processing {filename}: 'choices' not found in response.")
            print(f"Response content: {json.dumps(response, indent=2)}")
            return f"Error processing {filename}"
        
        # 将文件扩展名从 .sol 更改为 .txt
        new_filename = os.path.splitext(filename)[0] + '.txt'
        formatted_file_path = os.path.join(commented_code_dir, new_filename)
        
        with open(formatted_file_path, 'w', encoding='utf-8') as formatted_file:
            formatted_file.write(reply)
    
    return f"Processed {filename}"

def main():
    api_key = get_api_key()
    if not api_key:
        return
    
    if not os.path.exists(commented_code_dir):
        os.makedirs(commented_code_dir)
    
    sol_files = [f for f in os.listdir(source_code_dir) if f.endswith(".sol")]

    # 使用tqdm显示进度条
    total_files = len(sol_files)
    progress_bar = tqdm(total=total_files, desc="Processing files", unit="file")

    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(process_file, api_key, filename) for filename in sol_files]
        for future in as_completed(futures):
            result = future.result()
            # print(result)
            progress_bar.update(1)
    
    progress_bar.close()
    print("所有文件已经处理并保存到 functions_desc 文件夹中。")

if __name__ == "__main__":
    main()