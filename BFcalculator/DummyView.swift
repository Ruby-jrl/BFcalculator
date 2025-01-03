//
//  BodyModelView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 18/11/2024.
//

import SwiftUI
// currently dummy view - placeholder
struct DummyView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Title Text
            Text("Generic Test View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            // Description Text
            Text("This is a simple, generic view for testing purposes.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}
