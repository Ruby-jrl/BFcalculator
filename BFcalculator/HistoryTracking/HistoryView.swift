//
//  HistoryView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 24/01/2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {

        List {
            ForEach(Array(historyManager.entries.enumerated().reversed()), id: \.element.id) { index, entry in
                VStack(alignment: .leading) {
                    Text("Body Fat: \(String(format: "%.1f", entry.bodyFatPercentage))%")
                    Text("The method used is \(entry.method)")
                    Text("Date: \(entry.timestamp.formatted())")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: deleteEntries) // Attach directly to ForEach inside List
        }
        Button("Clear History") {
            historyManager.clearHistory()
        }
        .padding()
        .foregroundColor(.red)
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        let originalIndices = offsets.map { historyManager.entries.count - 1 - $0 }
        for index in originalIndices.sorted(by: >) {
            historyManager.entries.remove(at: index)
        }
    }
}
