//
//  ResultView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 03/01/2025.
//

import SwiftUI

struct ResultView: View {
    @State private var selectedTab = 0 // Default to the first page
    
    @Binding var fromPage: String
    @Binding var selectedGender: String
    @Binding var age: String
    @Binding var ethnicity: String
    @Binding var height: String
    @Binding var weight: String
    @Binding var waist: String
    @Binding var neck: String
    @Binding var hip: String


    var body: some View {
        VStack(spacing: 0) {
            // Top Picker acting as a tab
            Picker("Select Page", selection: $selectedTab) {
                Text("Result").tag(0)
                Text("Uncertainty").tag(1)
                Text("Nearest Neighbor").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle()) // Makes it look like a tab bar
            .padding()
            .background(Color(.systemGray6)) // Optional background for visibility
            .zIndex(1) // Ensures the picker stays above scrolling content

            // Display the selected view
            ScrollView {
                VStack {
                    if selectedTab == 0 {
                        ResultPage(
                            fromPage: fromPage,
                            selectedGender: selectedGender,
                            age: age,
                            ethnicity: ethnicity,
                            height: height,
                            weight: weight,
                            waist: waist,
                            neck: neck,
                            hip: hip
                        )
                    } else if selectedTab == 1 {
                        UncertaintyView(
                            fromPage: fromPage,
                            selectedGender: selectedGender,
                            age: age,
                            ethnicity: ethnicity,
                            height: height,
                            weight: weight,
                            waist: waist,
                            neck: neck,
                            hip: hip
                        )
                    } else {
                        NearestNView(
                            fromPage: fromPage,
                            selectedGender: selectedGender,
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
                .transition(.slide) // Optional animation when switching pages
                .animation(.default, value: selectedTab)
                .padding()
            }
        }
//        .onAppear {
//            print("View Loaded, fromPage = \(fromPage)") // Works inside .onAppear()
//                }
    }
    
}
