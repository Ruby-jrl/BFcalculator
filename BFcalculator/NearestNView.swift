//
//  NearestNView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 30/12/2024.
//
import Foundation

struct Neighbor: Identifiable {
    let id: String
    let features: [Double]
    let imageName: String
}

import SwiftUI

struct NearestNView: View {
    @State private var neighborsObjs: [Neighbor] = []
    
    let selectedGender: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    let featureNames = [
        "Height (cm)",
        "Weight (kg)",
        "Waist (cm)",
        "Hip (cm)",
        "Neck (cm)",
        "Body fat (%)"
    ]


    var body: some View {
        VStack {

            // Fetch Button
            Button(action: {processNearestNeighbors( // just adding {} solves the () @mainactor -> void problem  -why
                gender: selectedGender,
                age: age,
                height: height,
                weight: weight,
                waist: waist,
                neck: neck,
                hip: hip
            )}) {
                Text("Fetch Neighbors")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
            
            if neighborsObjs.isEmpty {
                Text("No Neighbors Found")
                    .font(.headline)
                    .padding()
            } else {
//                try make it horizontal scroll?
                ScrollView {
                    
                    // try make it work later
//                    if let path = Bundle.main.path(forResource: "R24800001", ofType: "jpg", inDirectory: "Fenland1"),
//                       let uiImage = UIImage(contentsOfFile: path) {
//                        Image(uiImage: uiImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 150)
//                            .cornerRadius(10)
//                            .padding(.bottom, 10)
//                    } else {
//                        // Use a placeholder if the image does not exist
//                        Image("dxa-placeholder")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(height: 150)
//                            .cornerRadius(10)
//                            .padding(.bottom, 10)
//                    }
                    
                    ForEach(neighborsObjs.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 10) {
                            // Title
                            Text("Neighbor \(index + 1)")
                                .bold()
                                .padding(.bottom, 5)

                            // Image
                            getImage(named: neighborsObjs[index].imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding(.bottom, 10)
                            

                            // Table
                            TableView(features: neighborsObjs[index].features, featureNames: featureNames)
                                .padding()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }

        }
    }

    // Simulated fetch function
    func processNearestNeighbors(gender: String, age: String, height: String, weight: String, waist: String, neck: String, hip: String) {
        
        // let userFeatures = [1, 22.5, 167, 50, 63, 84, 24.5] // dummy user data, replace with actual user input
        let userFeatures = [gender == "Male" ? "0" : "1", age, height, weight, waist, hip, neck].compactMap { Double($0) }
        // Filters out any elements that cannot be converted to Double.
        let k = 3 // Number of nearest neighbors to find
        
        
        // dummy neighbor data, replace with actual logic and neighbor data
//        neighbors = [
//            Neighbor(id: "1", features: [175, 50, 65, 84, 25, 20], imageName: "placeholder"),
//            Neighbor(id: "2", features: [175, 50, 65, 84, 25, 20], imageName: "placeholder"),
//            Neighbor(id: "3", features: [175, 50, 65, 84, 25, 20], imageName: "placeholder")
//        ]
        
        findNearestNeighbors(features: userFeatures, k: k) { neighbors in
            // Save the result in the @State variable
            if let neighbors = neighbors {
                DispatchQueue.main.async {
                    neighborsObjs = parseNeighbors(from: neighbors)
                }
                print(neighbors)
            } else {
                print("Failed to write to neighborsArr")
            }
            
        }
        // print(neighborsObjs) // empty - execution not blocked by finNearestNeighbors - need to ensure the subsequent code executes after the asynchronous task above completes
        
    }
}




struct TableView: View {
    let features: [Double]
    let featureNames: [String]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(features.indices, id: \.self) { index in
                HStack {
                    Text(featureNames[index]) // Use the feature name
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(features[index], specifier: "%.2f")")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.vertical, 5)
                Divider()
            }
        }
    }
}


private func getImage(named imageName: String) -> Image {
    if let uiImage = UIImage(named: imageName) {
        return Image(uiImage: uiImage)
    } else {
        return Image("dxa-placeholder")
    }
}
