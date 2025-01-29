//
//  BodyFatUncertaintyView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 28/11/2024.
//
import SwiftUI

// data model to represent each row in the table
struct UncertaintyMetrics {
    let metric: String
    let value: String
    let range: String
}

struct UncertaintyView: View {
    
    let fromPage: String
    let sex: String
    let age: String
    let ethnicity: String
    let height: String
    let weight: String
    let waist: String
    let neck: String
    let hip: String
    
    @State private var metrics: [UncertaintyMetrics] = []
    
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
            fetchMetrics()  // fetch asynchronously
        }
    }
    
    private func fetchMetrics() {
        UncertaintyView.prepareMetrics(
            fromPage: fromPage,
            gender: sex,
            age: age,
            ethnicity: ethnicity,
            height: height,
            weight: weight,
            waist: waist,
            neck: neck,
            hip: hip
        ) { result in
            DispatchQueue.main.async {
                metrics = result
            }
        }
    }
    
    private static func prepareMetrics(fromPage: String, gender: String, age: String, ethnicity: String, height: String, weight: String, waist: String, neck: String, hip: String, completion: @escaping ([UncertaintyMetrics]) -> Void) {
        
        let dispatchGroup = DispatchGroup()  // track async tasks

        var heightRange: [Double?] = [nil, nil]
        var weightRange: [Double?] = [nil, nil]
        var waistRange: [Double?] = [nil, nil]
        var neckRange: [Double?] = [nil, nil]
        var hipRange: [Double?] = [nil, nil]

        if fromPage == "Navy" {
            heightRange = [
                NavyMethodCalculator(sex: gender, waist: waist, neck: neck, height: String((Double(height) ?? 0) + 2), hip: hip) ?? 0,
                NavyMethodCalculator(sex: gender, waist: waist, neck: neck, height: String((Double(height) ?? 0) - 2), hip: hip) ?? 0
            ]
            
            waistRange = [
                NavyMethodCalculator(sex: gender, waist: String((Double(waist) ?? 0) - 2), neck: neck, height: height, hip: hip) ?? 0,
                NavyMethodCalculator(sex: gender, waist: String((Double(waist) ?? 0) + 2), neck: neck, height: height, hip: hip) ?? 0
            ]
            
            neckRange = [
                NavyMethodCalculator(sex: gender, waist: waist, neck: String((Double(neck) ?? 0) + 2), height: height, hip: hip) ?? 0,
                NavyMethodCalculator(sex: gender, waist: waist, neck: String((Double(neck) ?? 0) - 2), height: height, hip: hip) ?? 0
            ]
            
            hipRange = [
                NavyMethodCalculator(sex: gender, waist: waist, neck: neck, height: height, hip: String((Double(hip) ?? 0) - 2)) ?? 0,
                NavyMethodCalculator(sex: gender, waist: waist, neck: neck, height: height, hip: String((Double(hip) ?? 0) + 2)) ?? 0
            ]
            
            let heightError = (heightRange[0] == nil && heightRange[1] == nil) ? "-" :
                "\(String(format: "%.1f", heightRange[0] ?? 0)) - \(String(format: "%.1f", heightRange[1] ?? 0))%"
            
            let weightError = (weightRange[0] == nil && weightRange[1] == nil) ? "-" :
                "\(String(format: "%.1f", weightRange[0] ?? 0)) - \(String(format: "%.1f", weightRange[1] ?? 0))%"
                    
            let waistError = (waistRange[0] == nil && waistRange[1] == nil) ? "-" :
                "\(String(format: "%.1f", waistRange[0] ?? 0)) - \(String(format: "%.1f", waistRange[1] ?? 0))%"
            
            let neckError = (neckRange[0] == nil && neckRange[1] == nil) ? "-" :
                "\(String(format: "%.1f", neckRange[0] ?? 0)) - \(String(format: "%.1f", neckRange[1] ?? 0))%"
            
            let hipError = (hipRange[0] == nil && hipRange[1] == nil) ? "-" :
                gender == "Female" ? "\(String(format: "%.1f", hipRange[0] ?? 0)) - \(String(format: "%.1f", hipRange[1] ?? 0))%" : "-"
            
            completion([
                UncertaintyMetrics(metric: "Gender", value: gender, range: "-"),
                UncertaintyMetrics(metric: "Age", value: age, range: "-"),
                UncertaintyMetrics(metric: "Ethnicity", value: ethnicity, range: "-"),
                UncertaintyMetrics(metric: "Height", value: height + " ± 2", range: heightError),
                UncertaintyMetrics(metric: "Weight", value: weight + " ± 2", range: weightError),
                UncertaintyMetrics(metric: "Waist", value: waist + " ± 2", range: waistError),
                UncertaintyMetrics(metric: "Neck", value: neck + " ± 2", range: neckError),
                UncertaintyMetrics(metric: "Hip", value: hip + " ± 2", range: hipError)
            ])
            
        } else if fromPage == "NN" {

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: String((Double(height) ?? 0) + 2), weight: weight, waist: waist) { result in
                heightRange[0] = result ?? 0
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: String((Double(height) ?? 0) - 2), weight: weight, waist: waist) { result in
                heightRange[1] = result ?? 0
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: height, weight: String((Double(weight) ?? 0) - 2), waist: waist) { result in
                weightRange[0] = result ?? 0
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: height, weight: String((Double(weight) ?? 0) + 2), waist: waist) { result in
                weightRange[1] = result ?? 0
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: height, weight: weight, waist: String((Double(waist) ?? 0) - 2)) { result in
                waistRange[0] = result ?? 0
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            NNCalculator(sex: gender, height: height, weight: weight, waist: String((Double(waist) ?? 0) + 2)) { result in
                waistRange[1] = result ?? 0
                dispatchGroup.leave()
            }

            // notify when all async calls finish
            dispatchGroup.notify(queue: .main) {
                let heightError = (heightRange[0] == nil && heightRange[1] == nil) ? "-" :
                    "\(String(format: "%.1f", heightRange[0] ?? 0)) - \(String(format: "%.1f", heightRange[1] ?? 0))%"
                
                let weightError = (weightRange[0] == nil && weightRange[1] == nil) ? "-" :
                    "\(String(format: "%.1f", weightRange[0] ?? 0)) - \(String(format: "%.1f", weightRange[1] ?? 0))%"
                        
                let waistError = (waistRange[0] == nil && waistRange[1] == nil) ? "-" :
                    "\(String(format: "%.1f", waistRange[0] ?? 0)) - \(String(format: "%.1f", waistRange[1] ?? 0))%"
                
                let neckError = (neckRange[0] == nil && neckRange[1] == nil) ? "-" :
                    "\(String(format: "%.1f", neckRange[0] ?? 0)) - \(String(format: "%.1f", neckRange[1] ?? 0))%"
                
                let hipError = (hipRange[0] == nil && hipRange[1] == nil) ? "-" :
                    gender == "Female" ? "\(String(format: "%.1f", hipRange[0] ?? 0)) - \(String(format: "%.1f", hipRange[1] ?? 0))%" : "-"


                // construct and return the array of UncertaintyMetrics
                completion([
                    UncertaintyMetrics(metric: "Gender", value: gender, range: "-"),
                    UncertaintyMetrics(metric: "Age", value: age, range: "-"),
                    UncertaintyMetrics(metric: "Ethnicity", value: ethnicity, range: "-"),
                    UncertaintyMetrics(metric: "Height", value: height + " ± 2", range: heightError),
                    UncertaintyMetrics(metric: "Weight", value: weight + " ± 2", range: weightError),
                    UncertaintyMetrics(metric: "Waist", value: waist + " ± 2", range: waistError),
                    UncertaintyMetrics(metric: "Neck", value: neck + " ± 2", range: neckError),
                    UncertaintyMetrics(metric: "Hip", value: hip + " ± 2", range: hipError)
                ])
            }

        } else {
            completion([
                UncertaintyMetrics(metric: "Gender", value: gender, range: "-"),
                UncertaintyMetrics(metric: "Age", value: age, range: "-"),
                UncertaintyMetrics(metric: "Ethnicity", value: ethnicity, range: "-"),
                UncertaintyMetrics(metric: "Height", value: height + " ± 2", range: "-"),
                UncertaintyMetrics(metric: "Weight", value: weight, range: "-"),
                UncertaintyMetrics(metric: "Waist", value: waist + " ± 2", range: "-"),
                UncertaintyMetrics(metric: "Neck", value: neck + " ± 2", range: "-"),
                UncertaintyMetrics(metric: "Hip", value: hip + " ± 2", range: "-")
            ])
        }
    }

    
}
