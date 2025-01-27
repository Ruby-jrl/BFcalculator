//
//  nearstN.swift
//  BFcalculator
//
//  Created by Ruby Liu on 30/12/2024.
//


import Foundation

func parseNeighbors(from response: [[String: Any]]) -> [Neighbor] {
    var neighbors: [Neighbor] = []

    for entry in response {
        // Extract the ID or assign a default
        print(entry)
        let id = entry["id"] as? String ?? "Unknown"

        // Extract feature values with default fallback
        let height = entry["height"] as? Double ?? 0.0
        let weight = entry["weight"] as? Double ?? 0.0
        let waist = entry["waist_circumference"] as? Double ?? 0.0
        let hip = entry["hip_circumference"] as? Double ?? 0.0
        let neck = entry["neck_circumference"] as? Double ?? 0.0
        let bodyFat = entry["body_fat"] as? Double ?? 0.0

        // Combine features into an array
        let features = [height, weight, waist, hip, neck, bodyFat]

        // Create a Neighbor object
        let neighbor = Neighbor(id: id, features: features, imageName: id)

        // Add to the array
        neighbors.append(neighbor)
    }
    return neighbors
}

func findNearestNeighbors(fromPage: String, features: [Double], k: Int, completion: @escaping ([[String: Any]]?) -> Void) {
    // Define the API URL
    guard let url = URL(string: "http://127.0.0.1:5000/nearest_neighbors") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    // Create the JSON payload
    let payload: [String: Any] = [
        "fromPage": fromPage,
        "features": features,
        "k": k
    ]

    // Serialize the payload to JSON
    guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
        print("Error serializing JSON")
        completion(nil)
        return
    }

    // Create the POST request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData

    // Send the request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }

        // Parse the JSON response
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let neighbors = json["neighbors"] as? [[String: Any]] else {
            print("Invalid response")
            completion(nil)
            return
        }

        // Pass the neighbors to the completion handler
        completion(neighbors)
    }

    task.resume()
}
