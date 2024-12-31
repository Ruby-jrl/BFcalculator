//
//  nearstN.swift
//  BFcalculator
//
//  Created by Ruby Liu on 30/12/2024.
//


import Foundation

func findNearestNeighbors(features: [Double], k: Int, completion: @escaping ([[String: Any]]?) -> Void) {
    // Define the API URL
    guard let url = URL(string: "http://127.0.0.1:5000/nearest_neighbors") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    // Create the JSON payload
    let payload: [String: Any] = [
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
