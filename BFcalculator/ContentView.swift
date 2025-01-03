//
//  ContentView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 12/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Text("This app helps you estimate and track your body fat!")
                    .padding()
                
                NavigationLink(destination: NavyCalculatorView()) {
                    Text("Navy Method Calculator")
                        .font(.headline)
                        .padding()
                        .frame(width: 250)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: DummyView()) {
                    Text("Neural Network Method Calculator")
                        .font(.headline)
                        .padding()
                        .frame(width: 250)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: DummyView()) {
                    Text("History Tracking")
                        .font(.headline)
                        .padding()
                        .frame(width: 250)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: DummyView()) {
                    Text("Dummy page")
                        .font(.headline)
                        .padding()
                        .frame(width: 250)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("BFCalculator")
        }
        
    }
}




// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

