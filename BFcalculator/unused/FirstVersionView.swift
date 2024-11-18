//
//  FirstVersionView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 31/10/2024.
//



// this was body of contentview

//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 28) {
//
//                    SurveyFormView(selectedGender: $selectedGender, age: $age, ethnicity: $ethnicity, height: $height, weight: $weight, waist: $waist, neck: $neck, hip: $hip)
//
//                    // Header Section
//                    //HeaderView()
//
//                    // Demographic Section
//                    //DemographicSectionView(selectedGender: $selectedGender, age: $age, ethnicity: $ethnicity)
//
//                    // Body Metrics Section
//                    //BodyMetricsSectionView(selectedGender: $selectedGender, height: $height, weight: $weight, waist: $waist, neck: $neck, hip: $hip)
//
//                    // Result Button: Navigates to the ResultPage view
//                    //                    NavigationLink(destination: ResultPage(selectedGender: selectedGender, age: age, ethnicity: ethnicity, height: height, weight: weight, waist: waist, neck: neck, hip: hip)) {
//                    //                        Text("Result")
//                    //                            .font(Font.custom("Poppins", size: 20).weight(.semibold))
//                    //                            .foregroundColor(.white)
//                    //                            .frame(maxWidth: .infinity, minHeight: 50)
//                    //                            .background(Color(red: 0.14, green: 0.42, blue: 1))
//                    //                            .cornerRadius(10)
//                    //                            .padding(.horizontal)
//                    //
//                    //                    }
//                    Button(action: {
//                        showResultPage = true
//                    }) {
//                        Text("Show Result")
//                            .font(Font.custom("Poppins", size: 20).weight(.semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, minHeight: 50)
//                            .background(Color(red: 0.14, green: 0.42, blue: 1))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                    }
//                }
//                .fullScreenCover(isPresented: $showResultPage) {
//                    ResultPage(isPresented: $showResultPage, selectedGender: selectedGender, age: age, ethnicity: ethnicity, height: height, weight: weight, waist: waist, neck: neck, hip: hip)
//                }
//                .padding()
//                .background(Color(red: 0.88, green: 0.92, blue: 1))
//                .navigationTitle("Body Fat Calculator")  // Title of the navigation bar
//                .navigationBarHidden(true)  // Hide default navigation bar
//            }
//            .background(Color(red: 0.87, green: 0.92, blue: 1))
//            .ignoresSafeArea(edges: .bottom)  // Ignore safe area at the bottom if necessary
//
//        }
//    }


//
//
//
//
//// MARK: - Body Metrics Section with @Binding
//struct BodyMetricsSectionView: View {
//    @Binding var selectedGender: String
//    @Binding var height: String
//    @Binding var weight: String
//    @Binding var waist: String
//    @Binding var neck: String
//    @Binding var hip: String
//
//    var body: some View {
//        SectionView(title: "Body metric information") {
//            InputFieldView(label: "Height", value: $height, unit: "cm", defaultValue: "167", isGrayedOut: false)
//            InputFieldView(label: "Weight", value: $weight, unit: "kg", defaultValue: "50", isGrayedOut: false)
//            InputFieldView(label: "Waist", value: $waist, unit: "cm", defaultValue: "64", isGrayedOut: false)
//            InputFieldView(label: "Neck", value: $neck, unit: "cm", defaultValue: "32.5", isGrayedOut: false)
//            InputFieldView(label: "Hip", value: $hip, unit: "cm", defaultValue: "85", isGrayedOut: selectedGender == "Male")
//        }
//    }
//}
//
//// MARK: - InputFieldView with @Binding for Interactivity
//struct InputFieldView: View {
//    let label: String
//    @Binding var value: String
//    let unit: String
//    let defaultValue: String
//    let isGrayedOut: Bool  // New flag to control greyed-out behavior
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(isGrayedOut ? Color.gray.opacity(0.2) : Color.white)
//                .frame(height: 105)
//            
//            VStack(alignment: .leading, spacing: 0) {
//                Text(label)
//                    .font(Font.custom("Poppins", size: 20).weight(.medium))
//                    .foregroundColor(isGrayedOut ? .gray : Color(red: 0.55, green: 0.55, blue: 0.55))
//                    .padding(.bottom, 10)
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(isGrayedOut ? Color.gray.opacity(0.4) : Color(red: 0.88, green: 0.92, blue: 1))
//                        .frame(height: 45)
//                    
//                    HStack {
//                        TextField("", text: $value)
//                            .font(Font.custom("Poppins", size: 20))
//                            .foregroundColor(isGrayedOut ? .gray : (value == defaultValue ? .gray : .black))
//                            .keyboardType(.numberPad)  // Specify the keyboard type
//                            .disabled(isGrayedOut)
//                        
//                        Spacer()
//                        
//                        Text(unit)
//                            .font(Font.custom("Poppins", size: 20))
//                            .foregroundColor(isGrayedOut ? .gray : .black)
//                    }
//                    .padding(.horizontal)
//                    
//                    // Placeholder overlay - only shown when value is empty
//                    if value.isEmpty {
//                        HStack {
//                            Text(defaultValue)
//                                .font(Font.custom("Poppins", size: 20))
//                                .foregroundColor(.gray)
//                                .padding(.leading, 4)  // Padding to align with input text
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
//
//// MARK: - SectionView (Reusable)
//struct SectionView<Content: View>: View {
//    let title: String
//    let content: () -> Content
//
//    init(title: String, @ViewBuilder content: @escaping () -> Content) {
//        self.title = title
//        self.content = content
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text(title)
//                .font(Font.custom("Poppins", size: 16).weight(.medium))
//                .foregroundColor(.black)
//            content()
//        }
//    }
//}
