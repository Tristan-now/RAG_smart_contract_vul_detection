import json
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# 读取 JSON 文件
script_dir = os.path.dirname(os.path.abspath(__file__))
json_file = os.path.join(script_dir, 'results.json')
with open(json_file, 'r') as file:
    data = json.load(file)
# 将数据转换为 DataFrame
df = pd.DataFrame(data)

# 设置图表风格，使用内置的 'ggplot' 样式
plt.style.use('ggplot')

# 绘制 Mean Accuracy, Mean Precision, Mean Recall, Mean F1 Score 的折线图
plt.figure(figsize=(12, 8))

plt.plot(df['Threshold'], df['Mean Accuracy'], marker='o', label='Mean Accuracy')
plt.plot(df['Threshold'], df['Mean Precision'], marker='o', label='Mean Precision')
plt.plot(df['Threshold'], df['Mean Recall'], marker='o', label='Mean Recall')
plt.plot(df['Threshold'], df['Mean F1 Score'], marker='o', label='Mean F1 Score')

plt.xlabel('Threshold')
plt.ylabel('Score')
plt.title('Metrics vs. Threshold')
plt.legend()
plt.grid(True)
plt.savefig('metrics_vs_threshold.png')
plt.show()

# 绘制 Confusion Matrix 的条形图
for i, row in df.iterrows():
    matrix = row['Total Confusion Matrix']
    df_cm = pd.DataFrame(matrix, index=['True Negative', 'False Positive'], columns=['False Negative', 'True Positive'])

    plt.figure(figsize=(8, 6))
    ax = plt.subplot()
    cax = ax.matshow(df_cm, cmap='Blues')

    for (i, j), val in np.ndenumerate(matrix):
        ax.text(j, i, f'{val}', ha='center', va='center', color='red')

    plt.title(f'Confusion Matrix at Threshold {row["Threshold"]}')
    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.xticks(ticks=[0, 1], labels=['Negative', 'Positive'])
    plt.yticks(ticks=[0, 1], labels=['Negative', 'Positive'])
    plt.colorbar(cax)
    plt.savefig(f'confusion_matrix_{row["Threshold"]}.png')
    plt.show()