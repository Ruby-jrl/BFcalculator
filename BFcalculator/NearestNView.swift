//
//  NearestNView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 30/12/2024.
//
import Foundation

struct Neighbor: Identifiable {
    let id: Int
    let features: [Double]
    let imageName: String
}

import SwiftUI

struct NearestNView: View {
    @State private var neighbors: [Neighbor] = []
    
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
            Button(action: processNearestNeighbors) {
                Text("Fetch Neighbors")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
            
            if neighbors.isEmpty {
                Text("No Neighbors Found")
                    .font(.headline)
                    .padding()
            } else {
//                try make it horizontal scroll?
                ScrollView {
                    ForEach(neighbors) { neighbor in
                        VStack(alignment: .leading, spacing: 10) {
                            // Title
                            Text("Neighbor \(neighbor.id)")
                                .bold()
                                .padding(.bottom, 5)

                            // Image
                            Image(neighbor.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                                .padding(.bottom, 10)

                            // Table
                            TableView(features: neighbor.features, featureNames: featureNames)
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
    func processNearestNeighbors() {
        
        let userFeatures = [1, 22.5, 167, 50, 63, 84, 24.5] // dummy user data, replace with actual user input
        let k = 3 // Number of nearest neighbors to find

        findNearestNeighbors(features: userFeatures, k: k) { neighbors in
            if let neighbors = neighbors {
                print("Nearest Neighbors: \(neighbors)")
            } else {
                print("Failed to fetch neighbors")
            }
        }
        
        // dummy data, replace with actual logic
        neighbors = [
            Neighbor(id: 1, features: [175, 50, 65, 84, 25, 20], imageName: "placeholder"),
            Neighbor(id: 2, features: [175, 50, 65, 84, 25, 20], imageName: "placeholder"),
            Neighbor(id: 3, features: [175, 50, 65, 84, 25, 20], imageName: "placeholder")
        ]

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
