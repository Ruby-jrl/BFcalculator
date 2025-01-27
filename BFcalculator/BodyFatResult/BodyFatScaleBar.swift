//
//  BodyFatScaleBar.swift
//  BFcalculator
//
//  Created by Ruby Liu on 31/10/2024.
//

import SwiftUI

struct BodyFatScaleBar: View {
    let bodyFatRanges: [BodyFatRange]
    let calculatedBFPercentage: Double
    
    var body: some View {
        GeometryReader { geometry in
                let totalRange = bodyFatRanges.reduce(0) { $0 + $1.rangeWidth }
                VStack(alignment: .leading) {
                    // Scale Bar with Proportional Width Segments
                    HStack(spacing: 0) {
                        ForEach(bodyFatRanges) { range in
                            Rectangle()
                                .fill(range.color)
                                .frame(width: geometry.size.width * (range.rangeWidth / totalRange))
                        }
                    }
                    .frame(maxWidth: .infinity)  // Center the bar horizontally
                    .frame(height: 20)
                    .cornerRadius(3)
                    .overlay(
                        // Position the marker based on BF% within the scale bar
                        GeometryReader { geo in
                            let scaleWidth = geo.size.width
                            let minPercentage = bodyFatRanges.first?.minPercentage ?? 0
                            let adjustedBFPercentage = calculatedBFPercentage - minPercentage
                            let position = (adjustedBFPercentage / totalRange) * scaleWidth
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 2, height: 30)
                                .position(x: position, y: 10)
                        }
                    )
                    
                    // Labels for Each Range
                    HStack(spacing: 0) {
                        ForEach(bodyFatRanges) { range in
                            VStack(spacing: 4) {
                                Text(range.description)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text("\(Int(range.minPercentage)) - \(Int(range.maxPercentage))")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: geometry.size.width * (range.rangeWidth / totalRange))
                        }
                    }
                }
            }
            .frame(height: 60)  // Adjust the total height as needed
    }
}



struct BodyFatRange: Identifiable {
    let id = UUID()
    // Automatically generates a unique ID for each range - needed for it to be identifiable
    let description: String
    let minPercentage: Double
    let maxPercentage: Double
    let color: Color
    
    var rangeWidth: Double {
        return maxPercentage - minPercentage
    }
}


let maleBodyFatRanges = [
    BodyFatRange(description: "Athletes", minPercentage: 6, maxPercentage: 13, color: .green),
    BodyFatRange(description: "Fitness", minPercentage: 14, maxPercentage: 17, color: .blue),
    BodyFatRange(description: "Average", minPercentage: 18, maxPercentage: 24, color: .yellow),
    BodyFatRange(description: "Obese", minPercentage: 25, maxPercentage: 40, color: .red)
]

let femaleBodyFatRanges = [
    BodyFatRange(description: "Athletes", minPercentage: 14, maxPercentage: 20, color: .green),
    BodyFatRange(description: "Fitness", minPercentage: 21, maxPercentage: 24, color: .blue),
    BodyFatRange(description: "Average", minPercentage: 25, maxPercentage: 31, color: .yellow),
    BodyFatRange(description: "Obese", minPercentage: 32, maxPercentage: 40, color: .red)
]
