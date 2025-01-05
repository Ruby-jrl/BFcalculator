//
//  BodyFatUncertaintyView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 28/11/2024.
//
import SwiftUI

// Create a data model to represent each row in the table.
struct BodyMetric: Identifiable {
    var id = UUID()
    let metric: String
    let value: String
    let range: String
}



struct UncertaintyView: View {
    @State private var metrics: [BodyMetric] = []
    
    let fromPage: String
    let selectedGender: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    var body: some View {
        
        VStack {
            Text("Here is some information about how errors in body metric measurement would affect your body fat prediction. We consider ±2 cm error for measurements")
            
            // Header row
            HStack {
                Text("Metric").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
                Text("Value").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .center)
                Text("Range").fontWeight(.bold).frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.gray.opacity(0.2))

            // Data rows
            ForEach($metrics, id: \.metric) { $metric in
                HStack {
                    Text(metric.metric).frame(maxWidth: .infinity, alignment: .center)
                    Text(metric.value).frame(maxWidth: .infinity, alignment: .center)
                    Text(metric.range).frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 5)
                Divider()
            }
        }
        .onAppear {
            metrics = UncertaintyView.prepareMetrics(
                fromPage: fromPage,
                gender: selectedGender,
                age: age,
                ethnicity: ethnicity,
                height: height,
                weight: weight,
                waist: waist,
                neck: neck,
                hip: hip
            )
        }
    }
    
    
    private static func prepareMetrics(fromPage: String, gender: String, age: String, ethnicity: String, height: String, weight: String, waist: String, neck: String, hip: String) -> [BodyMetric] {
        // data manipulations here
        var heightRange: [Double]
        var waistRange: [Double]
        var neckRange: [Double]
        var hipRange: [Double]
        
        if fromPage == "Navy" {
            heightRange = [
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: neck, height: String((Double(height) ?? 0) + 2), hip: hip) ?? 0,
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: neck, height: String((Double(height) ?? 0) - 2), hip: hip) ?? 0
            ]
            
            waistRange = [
                NavyMethodCalculator(selectedGender: gender, waist: String((Double(waist) ?? 0) - 2), neck: neck, height: height, hip: hip) ?? 0,
                NavyMethodCalculator(selectedGender: gender, waist: String((Double(waist) ?? 0) + 2), neck: neck, height: height, hip: hip) ?? 0
            ]
            
            neckRange = [
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: String((Double(neck) ?? 0) + 2), height: height, hip: hip) ?? 0,
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: String((Double(neck) ?? 0) - 2), height: height, hip: hip) ?? 0
            ]
            
            hipRange = [
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: neck, height: height, hip: String((Double(hip) ?? 0) - 2)) ?? 0,
                NavyMethodCalculator(selectedGender: gender, waist: waist, neck: neck, height: height, hip: String((Double(hip) ?? 0) + 2)) ?? 0
            ]
            
        } else {
            heightRange = [0,0]
            waistRange = [0,0]
            neckRange = [0,0]
            hipRange = [0,0]
        }
        let hBFLowString = String(format: "%.1f", heightRange[0])
        let hBFHighString = String(format: "%.1f", heightRange[1])
        let heightError = hBFLowString + " - " + hBFHighString + "%"
        
        
        let wBFLowString = String(format: "%.1f", waistRange[0])
        let wBFHighString = String(format: "%.1f", waistRange[1])
        let waistError = wBFLowString + " - " + wBFHighString + "%"
        

        let nBFLowString = String(format: "%.1f", neckRange[0])
        let nBFHighString = String(format: "%.1f", neckRange[1])
        let neckError = nBFLowString + " - " + nBFHighString + "%"
        
        
        let hipBFLowString = String(format: "%.1f", hipRange[0])
        let hipBFHighString = String(format: "%.1f", hipRange[1])
        let hipError = gender == "Female" ? hipBFLowString + " - " + hipBFHighString + "%" : "-"
        

        // Construct and return the array of BodyMetric
        return [
            BodyMetric(metric: "Gender", value: gender, range: "-"),
            BodyMetric(metric: "Age", value: age, range: "-"),
            BodyMetric(metric: "Ethnicity", value: ethnicity, range: "-"),
            BodyMetric(metric: "Height", value: height + " ± 2", range: heightError),
            BodyMetric(metric: "Weight", value: weight, range: "-"),
            BodyMetric(metric: "Waist", value: waist + " ± 2", range: waistError),
            BodyMetric(metric: "Neck", value: neck + " ± 2", range: neckError),
            BodyMetric(metric: "Hip", value: hip + " ± 2", range: hipError)
        ]
    }
    
}
