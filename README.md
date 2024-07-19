# CotMLDetect: An Effective Smart Contract Vulnerability Detection Framework

## Overview

CotMLDetect is a state-of-the-art framework designed to detect vulnerabilities in smart contracts using a combination of Chain-of-Thought (CoT) reasoning and multimodal learning. This framework leverages the capabilities of large language models (LLMs) to enhance the accuracy and robustness of vulnerability detection.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
    - [Running the Detection](#running-the-detection)
    - [Examples](#examples)

## Features
- **Chain-of-Thought Reasoning**: Utilizes structured prompts to guide LLMs in understanding and detecting issues from textual descriptions.
- **Multimodal Learning**: Combines text features and control flow graphs (CFG) to capture the interaction and flow of operations within smart contracts.
- **Adaptive Framework**: Capable of detecting both text-sensitive and graph-sensitive vulnerabilities.

## Installation

To install CotMLDetect, follow these steps:

1. **Clone the Repository**:
    ```bash
    git clone URL
    cd CotMLDetect
    ```

2. **Set Up the Environment**:
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```

3. **Install Dependencies**:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

### Vulnerabilities Overview
1. **Delegatecall**: A function that allows one contract to call another contract's function, maintaining the context of the caller. It is text-sensitive because the vulnerability typically manifests in the contract code's function calls.
2. **Integer Overflow**: Occurs when arithmetic operations exceed the storage limit of a data type, causing unexpected behavior. This is also text-sensitive, as it relies on analyzing arithmetic operations in the contract code.
3. **Reentrancy**: A vulnerability where a contract's function makes an external call to another contract before updating its state, potentially leading to repeated function calls and unintended state changes. This requires graph-sensitive detection due to the need to analyze the contract's call graph.
4. **Timestamp**: A vulnerability that arises when a contract's behavior depends on the blockchain's timestamp, which can be manipulated by miners. This is graph-sensitive, as detecting it involves understanding the contract's state changes over time.

By using both CoT and multimodal learning-based branches, CotMLDetect ensures comprehensive vulnerability detection across different types of vulnerabilities in smart contracts.



### Running the Detection
To run the vulnerability detection, use the following command:

```bash
python ./text_sensitive_CoT_base/FC_vogage_classifier_fixed.py
```

### Examples
**Example 1: Text-Sensitive Vulnerability Detection**
```bash
python ./text_sensitive_CoT_base/FC_vogage_classifier_fixed.py
```

**Example 2: Graph-Sensitive Vulnerability Detection**
```bash
cd graph_sensitive_Multimodal_based/reentrancy/Multimodal_model
python fixed_sc+comment+cfg_concat_lightDBM.py
```
```bash
cd graph_sensitive_Multimodal_based/timestamp/Multimodal_model
python fixed_sc+comment+cfg_concat_lightDBM.py
```