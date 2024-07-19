import json
import os
import random
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.model_selection import train_test_split
from torch.utils.data import DataLoader, TensorDataset
from sklearn.metrics import confusion_matrix, classification_report, accuracy_score, precision_score, recall_score, f1_score
import pandas as pd
import ast

# 设置随机种子，保证实验可复现
def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.backends.cudnn.deterministic = True

set_seed(6742)  # 固定随机种子

# 定义函数数据集类
class FunctionDataset:
    def __init__(self, combined_data):
        # 确保 code_embeddings 和 desc_embeddings 是列表格式
        if isinstance(combined_data['code_embeddings'].iloc[0], str):
            combined_data['code_embeddings'] = combined_data['code_embeddings'].apply(lambda x: ast.literal_eval(x)[0])
        if isinstance(combined_data['desc_embeddings'].iloc[0], str):
            combined_data['desc_embeddings'] = combined_data['desc_embeddings'].apply(lambda x: ast.literal_eval(x)[0])
        
        self.code_embeddings = combined_data['code_embeddings'].tolist()
        self.desc_embeddings = combined_data['desc_embeddings'].tolist()
        self.labels = combined_data['label'].values  # 获取标签

# 定义模型
class FunctionClassifier(nn.Module):
    def __init__(self):
        super(FunctionClassifier, self).__init__()
        self.fc1_code = nn.Linear(768, 256)
        self.fc1_desc = nn.Linear(768, 256)
        self.fc2 = nn.Linear(512, 256)  # 输入大小为512（256+256）
        self.fc3 = nn.Linear(256, 128)
        self.fc4 = nn.Linear(128, 1)
        self.relu = nn.ReLU()

    def forward(self, code_emb, desc_emb):
        # 确保输入的形状正确
        code_emb = code_emb.view(-1, 768)
        desc_emb = desc_emb.view(-1, 768)
        
        code_out = self.relu(self.fc1_code(code_emb))
        desc_out = self.relu(self.fc1_desc(desc_emb))
        
        combined = torch.cat((code_out, desc_out), dim=1)  # 拼接后的大小为 (batch_size, 512)
        
        x = self.relu(self.fc2(combined))
        x = self.relu(self.fc3(x))
        x = self.fc4(x)
        return x

# 定义文件路径
script_dir = os.path.dirname(os.path.abspath(__file__))
embeddings_folder = os.path.join(script_dir, 'embeddings')

desc_file_0 = os.path.join(embeddings_folder, 'embeddings_desc_0.csv')
desc_file_1 = os.path.join(embeddings_folder, 'embeddings_desc_1_RAG.csv')
code_file_0 = os.path.join(embeddings_folder, 'embeddings_code_0.csv')
code_file_1 = os.path.join(embeddings_folder, 'embeddings_code_1.csv')

# 读取描述数据和代码数据
desc_data_0 = pd.read_csv(desc_file_0)
desc_data_1 = pd.read_csv(desc_file_1)
code_data_0 = pd.read_csv(code_file_0)
code_data_1 = pd.read_csv(code_file_1)

# 合并描述数据和代码数据
desc_data = pd.concat([desc_data_0, desc_data_1], ignore_index=True)
code_data = pd.concat([code_data_0, code_data_1], ignore_index=True)

# 处理嵌入列，将字符串转为列表
desc_data['desc_embeddings'] = desc_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])
code_data['code_embeddings'] = code_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])

# 确保desc_data和code_data有相同的contract_name
if 'contract_name' not in code_data.columns or 'contract_name' not in desc_data.columns:
    raise KeyError("确保输入数据包含 'contract_name' 列")

# 合并 code_data 和 desc_data，确保按 contract_name 匹配
combined_data = pd.merge(code_data[['contract_name', 'code_embeddings', 'label']], desc_data[['contract_name', 'desc_embeddings']], on='contract_name')

# 写入文件
combined_file_path = os.path.join(embeddings_folder, 'combined_desc_and_code.csv')
combined_data.to_csv(combined_file_path, index=False)

# 创建数据集实例
combined_dataset = FunctionDataset(combined_data)

# 提取嵌入和标签
code_embeddings = np.array(combined_dataset.code_embeddings)
desc_embeddings = np.array(combined_dataset.desc_embeddings)
labels = np.array(combined_dataset.labels).reshape(-1, 1)

# 计算正负样本的数量
positive_samples = sum(labels)
negative_samples = len(labels) - positive_samples

# 计算正样本的权重并转化为 Tensor
pos_weight = torch.tensor([negative_samples / positive_samples], dtype=torch.float32)

# 使用带有正样本权重的 BCEWithLogitsLoss
criterion = nn.BCEWithLogitsLoss(pos_weight)



# 进行 100 次训练
# 生成从 0.05 到 0.95 之间每次增加 0.05 的序列
# 定义结果存储列表
accuracies = []
precisions = []
recalls = []
f1_scores = []
confusion_matrices = []
for i in range(1, 101):
    set_seed(i)  # 设置不同的随机种子
    print(i)
    # 训练集和测试集拆分
    x_train_code, x_test_code, x_train_desc, x_test_desc, y_train, y_test = train_test_split(
        code_embeddings, desc_embeddings, labels, test_size=0.3, random_state=i)
    
    # 创建 TensorDataset 和 DataLoader
    train_dataset = TensorDataset(torch.tensor(x_train_code).float(), torch.tensor(x_train_desc).float(), torch.tensor(y_train).float())
    test_dataset = TensorDataset(torch.tensor(x_test_code).float(), torch.tensor(x_test_desc).float(), torch.tensor(y_test).float())

    train_dataloader = DataLoader(train_dataset, batch_size=32, shuffle=True)
    test_dataloader = DataLoader(test_dataset, batch_size=32, shuffle=False)

    # 初始化模型、优化器
    model = FunctionClassifier()
    optimizer = optim.Adam(model.parameters(), lr=0.0001)

    # 训练模型
    epochs = 100
    for epoch in range(epochs):
        for code_inputs, desc_inputs, targets in train_dataloader:
            optimizer.zero_grad()
            outputs = model(code_inputs, desc_inputs)
            loss = criterion(outputs, targets.float())
            loss.backward()
            optimizer.step()

    # 验证模型
    model.eval()
    with torch.no_grad():
        y_true, y_pred = [], []
        for code_inputs, desc_inputs, targets in test_dataloader:
            outputs = model(code_inputs, desc_inputs)
            outputs = torch.sigmoid(outputs)
            predicted = (outputs > 0.5).float()
            y_true.extend(targets.cpu().numpy())
            y_pred.extend(predicted.cpu().numpy())

        # 计算评估指标
        accuracies.append(accuracy_score(y_true, y_pred))
        precisions.append(precision_score(y_true, y_pred))
        recalls.append(recall_score(y_true, y_pred))
        f1_scores.append(f1_score(y_true, y_pred))
        confusion_matrices.append(confusion_matrix(y_true, y_pred))

# 计算平均值
mean_accuracy = np.mean(accuracies)
mean_precision = np.mean(precisions)
mean_recall = np.mean(recalls)
mean_f1_score = np.mean(f1_scores)

# 计算总和混淆矩阵
total_confusion_matrix = np.sum(confusion_matrices, axis=0)


print(f'Mean Accuracy: {mean_accuracy:.2f}')
print(f'Mean Precision: {mean_precision:.2f}')
print(f'Mean Recall: {mean_recall:.2f}')
print(f'Mean F1 Score: {mean_f1_score:.2f}')
print('Total Confusion Matrix:')
print(total_confusion_matrix)
