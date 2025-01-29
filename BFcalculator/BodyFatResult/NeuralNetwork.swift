//
//  NeuralNetwork.swift
//  BFcalculator
//
//  Created by Ruby Liu on 26/01/2025.
//

import Foundation

struct NNBodyMetrics: Codable {
    let sex: String
    let height: String
    let weight: String
    let waist: String
}

func NNCalculator(sex: String, height: String, weight: String, waist: String, completion: @escaping (Double?) -> Void) {
    
    let url = URL(string: "http://127.0.0.1:5000/predict")! // Local API URL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = NNBodyMetrics(sex: sex, height: height, weight: weight, waist: waist)
    
    guard let jsonData = try? JSONEncoder().encode(body) else {
        completion(nil)
        return
    }

    request.httpBody = jsonData

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            completion(nil)
            return
        }
        
        if let decodedResponse = try? JSONDecoder().decode([String: Double].self, from: data),
           let bodyFat = decodedResponse["body_fat"] {
            DispatchQueue.main.async {
                completion(bodyFat)
            }
        } else {
            completion(nil)
        }
    }.resume()
}

func asyncNNCalculatorWrapper(
    sex: String,
    height: String,
    weight: String,
    waist: String
) async -> Double? {
    await withCheckedContinuation { continuation in
        NNCalculator(sex: sex, height: height, weight: weight, waist: waist) { result in
            continuation.resume(returning: result)
        }
    }
}

// legacy code - to be migrated to asyc/await


