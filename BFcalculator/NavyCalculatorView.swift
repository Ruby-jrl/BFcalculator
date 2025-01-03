//
//  SurveyFormView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 17/10/2024.
//

import SwiftUI


struct NavyCalculatorView: View {
    @State private var fromPage: String = "Navy"
    
    @State private var selectedGender: String = ""
    @State private var age: String = ""
    @State private var ethnicity: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var waist: String = ""
    @State private var neck: String = ""
    @State private var hip: String = ""

    var body: some View {

        VStack {
            Text("The Navy method calculator uses the formula developed by the Naval Health Research Center, which uses your sex, height, waist, neck, and hip (only for female) measurements to estimate your body fat")
                .padding()
            
            Form {
                // Section for Demographic Information
                Section(header: Text("Demographic Information")) {
                    // Gender Picker
                    Picker("Gender", selection: $selectedGender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Section for Body Metric Information
                Section(header: Text("Body Metric Information")) {
                    // Height Input
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                        //.listRowSeparator(.visible)
                    
                    TextField("Waist (cm)", text: $waist)
                        .keyboardType(.decimalPad)
                        .listRowSeparator(.automatic)
                       
                    TextField("Neck (cm)", text: $neck)
                        .keyboardType(.decimalPad)
                        .listRowSeparator(.automatic)
                        
                    TextField("Hip (cm)", text: $hip)
                        .keyboardType(.decimalPad)
                        .disabled(selectedGender == "Male")
                        .opacity(selectedGender == "Male" ? 0.3 : 1.0) // field look disabled
                        .listRowSeparator(.automatic)
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
                
//                NavigationLink(destination: ResultPage(
//                    fromPage: "Navy",
//                    selectedGender: selectedGender,
//                    age: "",
//                    ethnicity: "",
//                    height: height,
//                    weight: "",
//                    waist: waist,
//                    neck: neck,
//                    hip: selectedGender == "Male" ? "" : hip
//                )) {
//                    Text("Submit")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
                NavigationLink(destination: ResultView(
                    fromPage: $fromPage,
                    selectedGender: $selectedGender,
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
        selectedGender = ""
        height = ""
        waist = ""
        neck = ""
        hip = ""
    }
}
