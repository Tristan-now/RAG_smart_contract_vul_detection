import os
os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'
import re
from transformers import BertTokenizer, BertModel
import torch
import faiss
import numpy as np
import pickle

# 加载漏洞报告文件
def load_reports(folder_path):
    reports = []
    for filename in os.listdir(folder_path):
        if filename.endswith('.txt'):
            with open(os.path.join(folder_path, filename), 'r', encoding='utf-8') as file:
                content = file.read()
                reports.append(content)
    return reports

# 文本清理函数
def clean_text(text):
    # 移除特殊字符和标点符号
    text = re.sub(r'[^\w\s]', '', text)
    return text

# 向量化文本
def vectorize_text(text, tokenizer, model):
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True, max_length=512)
    outputs = model(**inputs)
    # 使用CLS token的输出作为文本的向量表示
    vector = outputs.last_hidden_state[:, 0, :].detach().numpy()
    return vector

# 构建Faiss索引
def build_faiss_index(vectors):
    vectors_np = np.vstack(vectors)
    index = faiss.IndexFlatL2(vectors_np.shape[1])  # 使用L2距离
    index.add(vectors_np)
    return index

# 搜索功能
def search(query, index, tokenizer, model, top_k=3):
    query_vector = vectorize_text(query, tokenizer, model)
    distances, indices = index.search(query_vector, top_k)
    return distances, indices

def search_from_reports_embedding(query, top_k=3):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    folder_path = os.path.join(script_dir, 'reports_desc')
    target_file = os.path.join(script_dir, 'reports_embedding', 'reports_embedding.pkl')

    # 加载大小写敏感的BERT模型和tokenizer
    tokenizer = BertTokenizer.from_pretrained('bert-base-cased')
    model = BertModel.from_pretrained('bert-base-cased')
    
    # 加载并清理漏洞报告
    reports = load_reports(folder_path)
    cleaned_reports = [clean_text(report) for report in reports]
    
    # 检查是否已经存在向量化的漏洞报告文件
    if os.path.exists(target_file):
        with open(target_file, 'rb') as f:
            vectors = pickle.load(f)
    else:
        # 向量化漏洞报告
        vectors = [vectorize_text(report, tokenizer, model) for report in cleaned_reports]
        
        # 保存向量化的漏洞报告到文件
        with open(target_file, 'wb') as f:
            pickle.dump(vectors, f)
    # 构建Faiss索引
    index = build_faiss_index(vectors)
    
    # 示例查询
    distances, indices = search(query, index, tokenizer, model, top_k)
    
    # 打印和返回最相似的前top_k个报告
    most_similar_reports = [reports[idx] for idx in indices[0]]
    return most_similar_reports