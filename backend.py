# this is a backend python file - currently includes fetch neighbors endpoint and predict with neural network endpoint

from flask import Flask, request, jsonify
import pandas as pd
import numpy as np

app = Flask(__name__)

# root route - for testing purpose
@app.route('/', methods=['POST'])
def home():
    return "Welcome to the Flask API!"

# Load your CSV file
DATABASE_PATH = "cleaned_data_train.csv"
data = pd.read_csv(DATABASE_PATH)

# Endpoint to find nearest neighbors
@app.route('/nearest_neighbors', methods=['POST'])
def nearest_neighbors():
    # Parse user input from JSON request
    input_data = request.json
    fromPage = input_data["fromPage"]
    user_data = np.array(input_data["features"])  # Example: [1, 22.5, 167, 50, 63, 84, 24.5]
    k = input_data.get("k", 3)  # Default to 3 neighbors
    print(fromPage, user_data)


    # check input size - differs for different model: navy, neural network, my model etc.

    if fromPage == "Navy":
        feature_indices = [1, 2, 3, 4] # height, waist, hip, neck
        user_features = user_data[feature_indices]
        user_sex = user_data[0]
    
        # feature columns to check for nearest neighbor
        feature_columns = ["height", "waist_circumference", "hip_circumference", "neck_circumference"]
        data_features = data[feature_columns].values
    elif fromPage == "NN":
        feature_indices = [1, 2, 3] # height, weight, waist
        user_features = user_data[feature_indices]
        user_sex = user_data[0]

        # feature columns to check for nearest neighbor
        feature_columns = ["height", "weight", "waist_circumference"]
        data_features = data[feature_columns].values
    else:
        feature_indices = [2, 3, 4, 5, 6] # height, weight, waist, hip, neck
        user_features = user_data[feature_indices]
        user_sex = user_data[0]
    
        # Extract feature columns
        # id,sex,age,height,weight,waist_circumference,hip_circumference,neck_circumference,body_fat
        # feature columns to check for nearest neighbor
        feature_columns = ["height", "weight", "waist_circumference", "hip_circumference", "neck_circumference"]
        data_features = data[feature_columns].values

    # Compute distances (Euclidean)
    distances = np.linalg.norm(data_features - user_features, axis=1)

    # make sure gender is the same
    gender_column = data['sex'].values
    valid_indices = np.where(gender_column == user_sex)[0]
    filtered_distances = distances[valid_indices]

    # Get the nearest neighbors
    # nearest_indices = distances.argsort()[:k]
    nearest_indices = valid_indices[filtered_distances.argsort()[:k]]
    neighbors = data.iloc[nearest_indices].to_dict(orient="records")

    return jsonify({"neighbors": neighbors})



# testing post request
# curl -X POST -H "Content-Type: application/json" \
# -d '{"features": [1, 22.5, 167, 50, 63, 84, 24.5], "k": 3}' \
# http://127.0.0.1:5000/nearest_neighbors


import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim


class FullyConnectedBlock(nn.Module):
    def __init__(self, input_dim, output_dim, batch_norm=True, dropout=True, dropout_p=0.2):
        super(FullyConnectedBlock, self).__init__()

        self.dropout = dropout
        self.bn = batch_norm

        self.linear = nn.Linear(input_dim, output_dim)
        self.activation_func = nn.ReLU()
        self.batch_norm = nn.BatchNorm1d(output_dim)# if batch_norm else nn.Identity()
        self.dropout = nn.Dropout(p=dropout_p) #if dropout else nn.Identity()
    
    def forward(self, x):
        x = self.linear(x)

        if self.bn == True:
            x = self.batch_norm(x)

        x = self.activation_func(x)

        if self.dropout == True:
            x = self.dropout(x)
        return x


class FFWVariant(nn.Module):
    def __init__(self, input_dim=12, output_dim=1, bn=False): # 10 betas + height + weight
        super(FFWVariant, self).__init__()

        dim = 84
        # dim=120

        self.fc1 = FullyConnectedBlock(input_dim, dim, batch_norm=bn)
        self.fc2 = FullyConnectedBlock(dim, dim, batch_norm=bn)
        self.fc3 = FullyConnectedBlock(dim, dim, batch_norm=bn)
        self.fc4 = nn.Linear(dim, output_dim)

    def forward(self, x):
        x = self.fc1(x)
        x = self.fc2(x) + x
        x = self.fc3(x) + x
        x = self.fc4(x)
        return x


# Load PyTorch Model
model = FFWVariant(input_dim=5, output_dim=9)
model_weights = torch.load("waist_model.pth", map_location=torch.device('cpu'))
model.load_state_dict(model_weights, strict=False)
print(model)
model.eval()  # Set model to evaluation mode


@app.route('/predict', methods=['POST'])
def predict():
    print("start to predict")
    try:
        data = request.json # input data from Swift app
        sex = 0 if data["gender"] == "Male" else 1
        height = float(data["height"])
        weight = float(data["weight"])
        waist = float(data["waist"])
        print(sex, height, weight, waist)
        
        # Convert inputs into tensor
        input_tensor = torch.tensor([[sex, height, weight, weight/(height/100)**2, waist]], dtype=torch.float32)

        with torch.no_grad():
            model_output = model(input_tensor)
            total_fat = model_output[0,0].item() # in g
            body_fat = (total_fat / 1000) / weight * 100
            print(body_fat)

        return jsonify({"body_fat": body_fat})  # Send response back to Swift
    except Exception as e:
        print("error")
        return jsonify({"error": str(e)}), 400


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)  # Run on local machine

