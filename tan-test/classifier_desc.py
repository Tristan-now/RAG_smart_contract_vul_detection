import json
import os
import random

import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from sklearn.model_selection import train_test_split, KFold
from torch.utils.data import DataLoader, TensorDataset
from torch.utils.data import Dataset, DataLoader
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
from sklearn.metrics import classification_report
import pandas as pd
import ast
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# Fix model initialization
def set_seed(seed):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.backends.cudnn.deterministic = True

set_seed(6742)  # Set a fixed random seed   3369#####################################################################################

class FunctionDataset(object):
    def __init__(self, data_file):
        # Use pandas to read CSV file
        self.data = pd.read_csv(data_file)
        # Get embeddings and labels
        self.embeddings = [ast.literal_eval(emb)[0] for emb in self.data['embeddings']]
        self.labels = self.data['label'].values

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        return self.data[idx]

class FunctionClassifier(nn.Module):
    def __init__(self):
        super(FunctionClassifier, self).__init__()
        self.fc1 = nn.Linear(768, 512)
        self.fc2 = nn.Linear(512, 256)
        self.fc3 = nn.Linear(256, 128)
        self.fc4 = nn.Linear(128, 1)
        self.relu = nn.ReLU()

    def forward(self, x):
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        x = self.relu(x)
        x = self.fc3(x)
        x = self.relu(x)
        x = self.fc4(x)
        return x


# 定义目标文件夹
script_dir = os.path.dirname(os.path.abspath(__file__))
embeddings_folder = os.path.abspath(os.path.join(script_dir, 'embeddings'))

# 定义文件路径
desc_file_0 = os.path.join(embeddings_folder, 'embeddings_desc_0.csv')
desc_file_1 = os.path.join(embeddings_folder, 'embeddings_desc_1.csv')

# 读取 CSV 文件
data_0 = pd.read_csv(desc_file_0)
data_1 = pd.read_csv(desc_file_1)

# 合并数据
combined_data = pd.concat([data_0, data_1], ignore_index=True)
# 处理 embeddings 列，将单个列表变为嵌套列表
combined_data['embeddings'] = combined_data['embeddings'].apply(lambda x: [ast.literal_eval(x)])
# 保存合并后的数据到一个新的 CSV 文件
combined_file_path = os.path.join(embeddings_folder, 'combined_desc.csv')
combined_data.to_csv(combined_file_path, index=False)
desc_dataset = FunctionDataset(combined_file_path)

desc_embeddings = desc_dataset.embeddings
labels = desc_dataset.labels  # Assuming labels are the same for both datasets

x = np.array(desc_dataset.embeddings)
y = np.array(desc_dataset.labels)
y = y.reshape(-1, 1)

# Train test split
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state=0)  #42############################################
# Create a TensorDataset
train_dataset = TensorDataset(torch.tensor(x_train).float(), torch.tensor(y_train).float())
val_dataset = TensorDataset(torch.tensor(x_test).float(), torch.tensor(y_test).float())
# Create DataLoader
dataloader = DataLoader(train_dataset, batch_size=32, shuffle=True)
val_dataloader = DataLoader(val_dataset, batch_size=32, shuffle=False)

# Initialize the model and set the loss function and optimizer
model = FunctionClassifier()
criterion = nn.BCEWithLogitsLoss()
optimizer = optim.Adam(model.parameters(), lr=0.0001)

# Train the model
epochs = 100  ################################################################################################################
for epoch in range(epochs):
    for inputs, targets in dataloader:
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, targets.float())
        loss.backward()
        optimizer.step()
    print(f'Loss: {loss.item():.5f}')

# Validate the model
model.eval()
with torch.no_grad():
    total_batch_predictions = []
    total_batch_true_labels = []
    correct = 0
    total = 0
    for inputs, targets in val_dataloader:
        outputs = model(inputs)
        predicted = (outputs > 0.5).float()
        total += targets.size(0)
        correct += (predicted == targets).sum().item()
        total_batch_predictions.extend(predicted.cpu().numpy())
        total_batch_true_labels.extend(targets.cpu().numpy())

    y_true = total_batch_true_labels
    y_pred = total_batch_predictions

    overall_report = classification_report(y_true, y_pred, output_dict=True)
    print(f'Accuracy: {accuracy_score(y_true, y_pred):.2f}')
    print(f'Precision: {precision_score(y_true, y_pred):.2f}')
    print(f'Recall: {recall_score(y_true, y_pred):.2f}')
    print(f'F1 Score: {f1_score(y_true, y_pred):.2f}')

    print(classification_report(y_true, y_pred))
    cm = confusion_matrix(y_true, y_pred)
    print(cm)