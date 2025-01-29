//
//  ResultPage.swift
//  BFcalculator
//
//  Created by Ruby Liu on 13/10/2024.
//

import SwiftUI


struct ResultPage: View {
    @EnvironmentObject var historyManager: HistoryManager
    let fromPage: String
    
    let sex: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    @State private var bodyFat: Double? = nil
    
    var body: some View {
        
        let bodyFatRanges = sex == "Male" ? maleBodyFatRanges : femaleBodyFatRanges
        
        ScrollView{
            VStack(spacing: 20) {
                
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
                    Text("...")  // when calculation fails (i.e., nil)
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.red)
                }
                
                BodyFatTableView()
                
                // the button should ideally flash - to show user it is pressed - also consider not recording duplicates
                Button("Save to History") {
                    let newEntry = HistoryEntry(
                        id: UUID(),
                        timestamp: Date(),
                        bodyFatPercentage: bodyFat ?? 0.0,
                        method: fromPage
                    )
                    historyManager.addEntry(newEntry)
                    print("clicked save to history")
                    print(historyManager.entries)
                }
            }
        }
        .task {
            await calculateBodyFat()  // Fetch async data when view appears
        }
        .padding()
        
    }
    
    
    func calculateBodyFat() async {
        print("calculating body fat, fromPage: \(fromPage)")
        
        switch fromPage {
        case "Navy":
            print("navy branch")
            bodyFat = NavyMethodCalculator(sex: sex, waist: waist, neck: neck, height: height, hip: hip)
            
        case "NN":
            print("NN branch")
            NNCalculator (sex: sex, height: height, weight: weight, waist: waist) { result in
                if let value = result {
                    bodyFat = value
                } else {
                    print("No value received")
                }
            }

        default:
            print("wrong branch")
        }
    }

}


// Create a data model to represent each row in the table.
struct BodyFatCategory {
    let description: String
    let menRange: String
    let womenRange: String
}

// Define a view that takes a list of BodyFatCategory objects and displays them in a structured layout
struct BodyFatTableView: View {
    let categories: [BodyFatCategory] = [
        BodyFatCategory(description: "Athletes", menRange: "6-13%", womenRange: "14-20%"),
        BodyFatCategory(description: "Fitness", menRange: "14-17%", womenRange: "21-24%"),
        BodyFatCategory(description: "Average", menRange: "18-24%", womenRange: "25-31%"),
        BodyFatCategory(description: "Obese", menRange: "25%+", womenRange: "32%+")
    ]

    var body: some View {
        VStack {
            Text("Reference for Body Fat Ranges")
            
            // Header row
            HStack {
                Text("Description")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1) // text need be smaller - fit in line
                    .minimumScaleFactor(0.5)
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
                    Text(category.menRange)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(category.womenRange)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 8)
                Divider()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

