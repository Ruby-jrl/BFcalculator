//
//  SurveyFormView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 17/10/2024.
//

import SwiftUI


struct NavyCalculatorView: View {
    @State private var fromPage: String = "Navy"
    
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
                // Section for Demographic Information
                Section(header: Text("Demographic Information")) {
                    // Gender Picker
                    Picker("Sex", selection: $sex) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                
                // Section for Body Metric Information
                Section(header: Text("Body Metric Information")) {
                    // Height Input
                    TextField("Height (cm)", text: $height)
                        //.keyboardType(.decimalPad)
                        //.listRowSeparator(.visible)
                    TextField("Waist (cm)", text: $waist)
                    TextField("Neck (cm)", text: $neck)
                    TextField("Hip (cm) - disabled for male", text: $hip)
                        .disabled(sex == "Male")
                        .opacity(sex == "Male" ? 0.3 : 1.0) // field look disabled
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
        .navigationTitle("Navy Method")

    }
    
    
    // Reset function to clear all fields
    private func resetForm() {
        // Reset to default value
        sex = ""
        height = ""
        waist = ""
        neck = ""
        hip = ""
    }
}
