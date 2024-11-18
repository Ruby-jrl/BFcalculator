//
//  SurveyFormView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 17/10/2024.
//

import SwiftUI


//struct SurveyFormView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            // Title Text
//            Text("Generic Test View")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.top)
//            
//            // Description Text
//            Text("This is a simple, generic view for testing purposes.")
//                .font(.body)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal)
//        }
//    }
//}



//struct SurveyFormView: View {
//    @Binding var selectedGender: String
//    @Binding var age: String
//    @Binding var ethnicity: String
//    @Binding var height: String
//    @Binding var weight: String
//    @Binding var waist: String
//    @Binding var neck: String
//    @Binding var hip: String
//    @State private var notificationsEnabled: Bool = true
//    
//    // Ethnicity options
//    let ethnicities = ["General", "Southeast Asian", "African", "Caucasian", "Latino", "Other"]
//    
//    @State private var showResultPage = false
//    var onSubmit: () -> Void  // Closure to handle submit action
//
//    var body: some View {
//        NavigationView {
//            if showResultPage {
//                ResultPage(isPresented: $showResultPage, selectedGender: selectedGender, age: age, ethnicity: ethnicity, height: height, weight: weight, waist: waist, neck: neck, hip: hip)
//            } else {
//                Form {
//                    // Section for Demographic Information
//                    Section(header: Text("Demographic Information")) {
//                        // Gender Picker
//                        Picker("Gender", selection: $selectedGender) {
//                            Text("Male").tag("Male")
//                            Text("Female").tag("Female")
//                        }
//                        .pickerStyle(SegmentedPickerStyle())
//                        
//                        // Age Input
//                        TextField("Age", text: $age)
//                            .keyboardType(.numberPad)
//                        
//                        // Ethnicity Picker
//                        Picker("Select Ethnicity", selection: $ethnicity) {
//                            ForEach(ethnicities, id: \.self) { ethnicityOption in
//                                Text(ethnicityOption).tag(ethnicityOption)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())  // Dropdown menu style
//                        .foregroundColor(ethnicity.isEmpty ? .gray : .black)
//                    }
//                    
//                    // Section for Body Metric Information
//                    Section(header: Text("Body Metric Information")) {
//                        // Height Input
//                        TextField("Height (cm)", text: $height)
//                            .keyboardType(.decimalPad)
//                        
//                        // Weight Input
//                        TextField("Weight (kg)", text: $weight)
//                            .keyboardType(.decimalPad)
//                        
//                        TextField("Waist (cm)", text: $waist)
//                            .keyboardType(.decimalPad)
//                        
//                        TextField("Neck (cm)", text: $neck)
//                            .keyboardType(.decimalPad)
//                        
//                        TextField("Hip (cm)", text: $hip)
//                            .keyboardType(.decimalPad)
//                        
//                    }
//                    
//                    // Section for Notifications Toggle
//                    //Section {
//                    //    Toggle("Enable Notifications", isOn: $notificationsEnabled)
//                    //}
//                    
//                    // Button to submit or take action
//                    Section {
//                        Button(action: {
//                            showResultPage = true
//                            onSubmit()
//                        }) {
//                            Text("Back")
//                                .frame(maxWidth: .infinity, alignment: .center)
//                                .foregroundColor(.blue)
//                        }
//                        
//                   
//                        
//                        Button("Show Body Fat Calculator Result") {
//                            showResultPage = true
//                        }
//                        .fullScreenCover(isPresented: $showResultPage) {
//                            NavigationView {
//                                ResultPage(isPresented: $showResultPage, selectedGender: selectedGender, age: age, ethnicity: ethnicity, height: height, weight: weight, waist: waist, neck: neck, hip: hip)
//                            }
//                            .navigationViewStyle(StackNavigationViewStyle())
//                            .ignoresSafeArea(edges: .top) // Extend to top of screen
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        
//                        
//                        
//                    }
//                }
//                .navigationBarTitle("Body Fat Calculator", displayMode: .inline)
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}





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
                    
                }
            }
            // end of form
            
            
            HStack {
                NavigationLink(destination: ResultPage(
                        selectedGender: selectedGender,
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
}
