//
//  NeuralNetworkView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 07/01/2025.
//


import SwiftUI

struct NeuralNetworkView: View {
    @State private var fromPage: String = "NN"
    
    @State private var selectedGender: String = ""
    @State private var age: String = ""
    @State private var ethnicity: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var waist: String = ""
    @State private var neck: String = ""
    @State private var hip: String = ""

    var body: some View {
        VStack {
            
            Form {
                Section(header: Text("Demographic Information")) {
                    Picker("Gender", selection: $selectedGender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Body Metric Information")) {
                    TextField("Height (cm)", text: $height)
                    TextField("Weight (kg)", text: $weight)
                    TextField("Waist (cm)", text: $waist)
                }
            }
            
            HStack {
                // Reset Button
                Button(action: {
                    resetForm()
                }) {
                    Text("Reset")
                        .font(.headline)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer()
                
                NavigationLink(destination: ResultView(
                    fromPage: $fromPage,
                    selectedGender: $selectedGender,
                    age: $age,
                    ethnicity: $ethnicity,
                    height: $height,
                    weight: $weight,
                    waist: $waist,
                    neck: $neck,
                    hip: $hip
                )) {
                    Text("Submit")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("FNN Method")
        
    }
    
    // Reset function to clear all fields
    private func resetForm() {
        selectedGender = ""
        height = ""
        weight = ""
        waist = ""
    }
}




// Call API from Swift

import Foundation

struct BodyMetrics: Codable {
    let gender: String
    let height: String
    let weight: String
    let waist: String
//    let hip: Double
}

func NNCalculator(gender: String, height: String, weight: String, waist: String, completion: @escaping (Double?) -> Void) {
    
    let url = URL(string: "http://127.0.0.1:5000/predict")! // Local API URL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = BodyMetrics(gender: gender, height: height, weight: weight, waist: waist)
    
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

