//
//  SurveyFormView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 17/10/2024.
//

import SwiftUI


struct SurveyFormView: View {
    @Binding var selectedGender: String
    @Binding var age: String
    @Binding var ethnicity: String
    @Binding var height: String
    @Binding var weight: String
    @Binding var waist: String
    @Binding var neck: String
    @Binding var hip: String
    @State private var notificationsEnabled: Bool = true
    
    // Ethnicity options
    let ethnicities = ["General", "Southeast Asian", "African", "Caucasian", "Latino", "Other"]


    var body: some View {

        VStack {
            
            Form {
                // Section for Demographic Information
                Section(header: Text("Demographic Information")) {
                    // Gender Picker
                    Picker("Gender", selection: $selectedGender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    // Age Input
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    
                    // Ethnicity Picker
                    Picker("Select Ethnicity", selection: $ethnicity) {
                        ForEach(ethnicities, id: \.self) { ethnicityOption in
                            Text(ethnicityOption).tag(ethnicityOption)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())  // Dropdown menu style
                    .foregroundColor(ethnicity.isEmpty ? .gray : .black)
                }
                
                // Section for Body Metric Information
                Section(header: Text("Body Metric Information")) {
                    // Height Input
                    TextField("Height (cm)", text: $height)
                        .keyboardType(.decimalPad)
                    
                    // Weight Input
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                    
                    TextField("Waist (cm)", text: $waist)
                        .keyboardType(.decimalPad)
                    
                    TextField("Neck (cm)", text: $neck)
                        .keyboardType(.decimalPad)
                    
                    TextField("Hip (cm)", text: $hip)
                        .keyboardType(.decimalPad)
                        .disabled(selectedGender == "Male")
                        .foregroundColor(selectedGender == "Male" ? .gray : .primary)
                    
                }
            }
            // end of form
            
            
            HStack {
                
                // Reset Button
                Button(action: {
                    resetForm()
                }) {
                    Text("Reset")
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
                
                NavigationLink(destination: ResultPage(
                    fromPage: "",
                    sex: selectedGender,
                    age: age,
                    ethnicity: ethnicity,
                    height: height,
                    weight: weight,
                    waist: waist,
                    neck: neck,
                    hip: hip
                )) {
                    Text("Submit")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Body Fat Calculator")
            
    }
    
    
    // Reset function to clear all fields
    private func resetForm() {
        selectedGender = "" // Reset to default value
        age = ""
        ethnicity = ""
        height = ""
        weight = ""
        waist = ""
        neck = ""
        hip = ""
        // Reset other fields as necessary
    }
}
