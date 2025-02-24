//
//  MLP1Calculator.swift
//  BFcalculator
//
//  Created by Ruby Liu on 12/02/2025.
//

import SwiftUI

struct MLP1CalculatorView: View {
    @State private var fromPage: String = "MLP1"
    
    @State private var sex: String = ""
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
                    Picker("Sex", selection: $sex) {
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
                    sex: $sex,
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
        .navigationTitle("MLP1 Method")
        
    }
    
    // Reset function to clear all fields
    private func resetForm() {
        sex = ""
        height = ""
        weight = ""
        waist = ""
    }
}
