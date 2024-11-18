//
//  ResultPage.swift
//  BFcalculator
//
//  Created by Ruby Liu on 13/10/2024.
//

import SwiftUI


struct ResultPage: View {
    let selectedGender: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    var body: some View {
        
        let bodyFatRanges = selectedGender == "Male" ? maleBodyFatRanges : femaleBodyFatRanges
        
        ScrollView{
            VStack(spacing: 20) {
                // Header Information
                Text("Based on the information you provided, your Body Fat Percentage is:")
                    .foregroundColor(Color(red: 0.14, green: 0.42, blue: 1))
                
                // Body Fat Percentage Section
                VStack(alignment: .center, spacing: 15) {
                    
                    if let bodyFat = calculateBodyFatPercentage() {
                        Text(String(format: "%.1f", bodyFat))
                            .font(Font.custom("Poppins", size: 100).weight(.semibold))
                            .foregroundColor(Color(red: 0.14, green: 0.42, blue: 1))
                        
                        // Scale bar
                        BodyFatScaleBar(bodyFatRanges: bodyFatRanges, calculatedBFPercentage: bodyFat)
                        
                    } else {
                        Text("N/A")  // Display "N/A" or some default text when calculation fails (i.e., nil)
                            .font(Font.custom("Poppins", size: 100).weight(.semibold))
                            .foregroundColor(.red)
                    }
                    
                }
                
                
                // Body Fat Description
                Text("explanation of body fat ranges")
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                Text("Body Fat Ranges")
                    .onAppear {
                        print("Body Fat Ranges:")
                        for range in bodyFatRanges {
                            print("Description: \(range.description), Min: \(range.minPercentage)%, Max: \(range.maxPercentage)%")
                        }
                    }
                
                BodyFatTableView()
            }
        }
        .padding()
        
    }

    
    func calculateBodyFatPercentage() -> Double? {
        
        if let waistNum = Double(waist),
           let neckNum = Double(neck),
           let heightNum = Double(height) { // Convert heightString to Double
            
            if selectedGender == "Male" {
                // Formula for men
                // 495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height)) - 450
                let waistMinusNeck = waistNum - neckNum
                let logWaistNeck = log10(waistMinusNeck)
                let logHeight = log10(heightNum)
                let factor = 1.0324 - 0.19077 * logWaistNeck + 0.15456 * logHeight
                return 495 / factor - 450
            } else if let hipNum = Double(hip) {
                // Formula for women
                // 495 / (1.29579 - 0.35004 * log10(waist + hip - neck) + 0.22100 * log10(height)) - 450
                let waistPlusHipMinusNeck = waistNum + hipNum - neckNum
                let logWaistHipNeck = log10(waistPlusHipMinusNeck)
                let logHeight = log10(heightNum)
                let factor = 1.29579 - 0.35004 * logWaistHipNeck + 0.22100 * logHeight
                return 495 / factor - 450
            } else {
                return nil
            }
        }
    
        return nil
    }
    
}




// Create a data model to represent each row in the table.
struct BodyFatCategory {
    let description: String
    let men: String
    let women: String
}

// Define a view that takes a list of BodyFatCategory objects and displays them in a structured layout
struct BodyFatTableView: View {
    let categories: [BodyFatCategory] = [
        BodyFatCategory(description: "Athletes", men: "6-13%", women: "14-20%"),
        BodyFatCategory(description: "Fitness", men: "14-17%", women: "21-24%"),
        BodyFatCategory(description: "Average", men: "18-24%", women: "25-31%"),
        BodyFatCategory(description: "Obese", men: "25%+", women: "32%+")
    ]

    var body: some View {
        VStack {
            // Header row
            HStack {
                Text("Description")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Men")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Women")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.2))

            // Data rows
            ForEach(categories, id: \.description) { category in
                HStack {
                    Text(category.description)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(category.men)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(category.women)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 8)
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
//        .shadow(radius: 2)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

