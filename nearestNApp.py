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
    user_data = np.array(input_data["features"])  # Example: [1, 22.5, 167, 50, 63, 84, 24.5]
    feature_indices = [2, 3, 4, 5, 6] # height, weight, waist, hip, neck
    user_features = user_data[feature_indices]
    user_sex = user_data[0]
    k = input_data.get("k", 3)  # Default to 3 neighbors

    # Extract feature columns
    # id,sex,age,height,weight,waist_circumference,hip_circumference,neck_circumference,body_fat
    # feature columns to check for nearest neighbour
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


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)


# testing post request
# curl -X POST -H "Content-Type: application/json" \
# -d '{"features": [1, 22.5, 167, 50, 63, 84, 24.5], "k": 3}' \
# http://127.0.0.1:5000/nearest_neighbors
