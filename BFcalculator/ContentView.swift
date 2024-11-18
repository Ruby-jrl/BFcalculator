//
//  ContentView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 12/10/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedGender: String = ""
    @State private var age: String = ""
    @State private var ethnicity: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var waist: String = ""
    @State private var neck: String = ""
    @State private var hip: String = ""
    
    @State private var showSurveyForm = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Text("Importance of Knowing and Monitoring Body Fat")
                    .padding()
                
                NavigationLink(destination: SurveyFormView(
                    selectedGender: $selectedGender,
                    age: $age,
                    ethnicity: $ethnicity,
                    height: $height,
                    weight: $weight,
                    waist: $waist,
                    neck: $neck,
                    hip: $hip
                )) {
                    Text("Open Body Fat Calculator")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: BodyModelView()) {
                    Text("Your 3D Body Model")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Home")
        }
        
    }
}




// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

