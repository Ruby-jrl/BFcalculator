//
//  BFcalculatorApp.swift
//  BFcalculator
//
//  Created by Ruby Liu on 12/10/2024.
//

import SwiftUI

@main //entry point of a program - main()
struct BFcalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HistoryManager())
        }
    }
}
