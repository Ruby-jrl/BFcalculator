//
//  ResultPage.swift
//  BFcalculator
//
//  Created by Ruby Liu on 13/10/2024.
//

import SwiftUI


struct ResultPage: View {
    let fromPage: String
    
    let selectedGender: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    func calculateBodyFat() -> Double? {
        print("fromPage: \(fromPage)")
        switch fromPage {
        case "Navy":
            print("navy branch")
            return NavyMethodCalculator(selectedGender: selectedGender, waist: waist, neck: neck, height: height, hip: hip)
//        case "NN":
//            return ArmyMethodCalculator(selectedGender: selectedGender, waist: waist, neck: neck, height: height)
        default:
            print("wrong branch")
            return nil
        }
    }
    
    var body: some View {
        
        let bodyFatRanges = selectedGender == "Male" ? maleBodyFatRanges : femaleBodyFatRanges
        let bodyFat = calculateBodyFat()
        
        ScrollView{
            VStack(spacing: 20) {
                // Header Information
                Text("Based on the information you provided, your Body Fat Percentage is:")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 1))
                
                // Body Fat Percentage Section
                if let bodyFat = bodyFat {
                    Text(String(format: "%.1f", bodyFat))
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 1))
                    
                    // Scale bar
                    BodyFatScaleBar(bodyFatRanges: bodyFatRanges, calculatedBFPercentage: bodyFat)
                    
                } else {
                    Text("N/A")  // when calculation fails (i.e., nil)
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                }
                
                BodyFatTableView()
                
                
                Button(action: {
                    print("record button was tapped!")
                }) {
                    Text("Record this result")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                
                BodyFatUncertaintyView(
                    selectedGender: selectedGender,
                    age: age,
                    ethnicity: ethnicity,
                    height: height,
                    weight: weight,
                    waist: waist,
                    neck: neck,
                    hip: hip
                )
            }
            
            NearestNView(
                selectedGender: selectedGender,
                age: age,
                ethnicity: ethnicity,
                height: height,
                weight: weight,
                waist: waist,
                neck: neck,
                hip: hip
            )
            
        }
        .padding()
        
    }
}


func NavyMethodCalculator(selectedGender: String, waist: String, neck: String, height: String, hip: String) -> Double? {
    
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
            Text("Reference for Body Fat Ranges")
            
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

