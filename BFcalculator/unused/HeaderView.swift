////
////  HeaderView.swift
////  BFcalculator
////
////  Created by Ruby Liu on 16/10/2024.
////
//
//import SwiftUI
//
//struct HeaderView: View {
//    var body: some View {
//        VStack(spacing: 10) {
//            // Welcome Section
//            HStack {
//                Text("Welcome! ")
//                    .font(Font.custom("Poppins", size: 18).weight(.medium))
//                    .foregroundColor(.black)
//                Image("icons8-smile-24")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 25, height: 25)
//            }
//            
//            // Main Title
//            Text("Body Fat Calculator")
//                .font(Font.custom("Poppins", size: 34).weight(.semibold))
//                .foregroundColor(.black)
//                .padding(.bottom, 8)
//            
//            // Description
//            Text("We encourage you to fill in all the following information to get the most accurate estimate of your body fat percentage.")
//                .font(Font.custom("Poppins", size: 14))
//                .foregroundColor(.black)
//                .multilineTextAlignment(.center)
//                .frame(maxWidth: .infinity)
//                .padding(.horizontal, 20)
//        }
//        .frame(maxWidth: .infinity, minHeight: 150)
//        .padding(.vertical, 20)
//
//    }
//}
//
//// MARK: - Demographic Section with @Binding
//struct DemographicSectionView: View {
//    @Binding var selectedGender: String
//    @Binding var age: String
//    @Binding var ethnicity: String
//    
//    // Ethnicity options
//    let ethnicities = ["General", "Southeast Asian", "African", "Caucasian", "Latino", "Other"]
//
//    var body: some View {
//        SectionView(title: "Demographic information") {
//            GenderSelectionView(selectedGender: $selectedGender)
//            InputFieldView(label: "Age", value: $age, unit: "years", defaultValue: "22", isGrayedOut: false)
//            // InputFieldView(label: "Ethnicity", value: $ethnicity, unit: "", defaultValue: "General")
//            EthnicityPickerView(ethnicity: $ethnicity, ethnicities: ethnicities)
//        }
//    }
//}
//
//// MARK: - Gender Selection View with @Binding
//struct GenderSelectionView: View {
//    @Binding var selectedGender: String
//
//    var body: some View {
////        HStack(spacing: 16) {
////            GenderButton(label: "Male", isSelected: selectedGender == "Male") {
////                selectedGender = "Male"
////            }
////            GenderButton(label: "Female", isSelected: selectedGender == "Female") {
////                selectedGender = "Female"
////            }
////        }
//        Picker("Select Gender", selection: $selectedGender) {
//            Text("Male").tag("Male")
//            Text("Female").tag("Female")
//        }
//        .pickerStyle(SegmentedPickerStyle())
//        .padding()
//    }
//}
//
//// Gender Button for Gender Selection
//struct GenderButton: View {
//    let label: String
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Text(label)
//                .font(Font.custom("Poppins", size: 15).weight(.medium))
//                .foregroundColor(isSelected ? .white : Color(red: 0.14, green: 0.42, blue: 1))
//                .frame(width: 90, height: 45)
//                .background(isSelected ? Color(red: 0.14, green: 0.42, blue: 1) : Color.white)
//                .cornerRadius(10)
//        }
//    }
//}
//
//// MARK: - Ethnicity Picker View
//struct EthnicityPickerView: View {
//    @Binding var ethnicity: String
//    let ethnicities: [String]  // List of ethnicities to choose from
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.white)
//                .frame(height: 105)
//
//            VStack(alignment: .leading, spacing: 0) {
//                Text("Ethnicity")
//                    .font(Font.custom("Poppins", size: 20).weight(.medium))
//                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
//                    .padding(.bottom, 10)
//
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color(red: 0.88, green: 0.92, blue: 1))
//                        .frame(height: 45)
//
//                    HStack {
//                        Picker("Select Ethnicity", selection: $ethnicity) {
//                            ForEach(ethnicities, id: \.self) { ethnicityOption in
//                                Text(ethnicityOption).tag(ethnicityOption)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())  // Dropdown menu style
//                        .foregroundColor(ethnicity.isEmpty ? .gray : .black)  // Placeholder color logic
//                        
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
//                    // Placeholder text if no ethnicity is selected
//                    if ethnicity.isEmpty {
//                        HStack {
//                            Text("Select Ethnicity")
//                                .font(Font.custom("Poppins", size: 20))
//                                .foregroundColor(.gray)
//                                .padding(.leading, 4)
//                            Spacer()
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .frame(width: 359)
//    }
//}
