import glob
import os

import kagglehub
import pandas as pd

# Download latest version
path = kagglehub.dataset_download("pavansubhasht/ibm-hr-analytics-attrition-dataset")

print("Path to dataset files:", path)

csv_files = glob.glob(os.path.join(path, "*.csv"))
if not csv_files:
	raise FileNotFoundError("No CSV files found in the dataset path.")

csv_path = csv_files[0]
df = pd.read_csv(csv_path)
print("CSV file:", csv_path)
print(df.head(5))