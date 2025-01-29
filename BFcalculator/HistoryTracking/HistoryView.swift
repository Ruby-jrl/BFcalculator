//
//  HistoryView.swift
//  BFcalculator
//
//  Created by Ruby Liu on 24/01/2025.
//

import SwiftUI
import Charts // Import for Swift Charts (iOS 16+)

struct HistoryView: View {
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        TabView {
            // Tab 1: List of Entries
            ListView(historyManager: _historyManager)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }

            // Tab 2: Graph Plot
            GraphView(historyManager: _historyManager)
                .tabItem {
                    Label("Graph", systemImage: "chart.bar.xaxis")
                }
        }
    }
}


struct GraphView: View {
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        let groupedEntries = historyManager.entries.firstEntryGroupedByMinute()
        
        Chart(groupedEntries) { entry in
            BarMark(
                x: .value("Date", entry.timestamp, unit: .minute), // Use date on the x-axis
                y: .value("Body Fat", entry.bodyFatPercentage)  // Body fat percentage on the y-axis
            )
        }
        .padding()
        .navigationTitle("Body Fat Trends")
    }
}


struct ListView: View {
    @EnvironmentObject var historyManager: HistoryManager

    var body: some View {
        VStack {
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
            .listStyle(PlainListStyle())
            
            Button("Clear History") {
                historyManager.clearHistory()
            }
            .padding()
            .foregroundColor(.red)
        }
        .navigationTitle("History List")
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        let originalIndices = offsets.map { historyManager.entries.count - 1 - $0 }
        for index in originalIndices.sorted(by: >) {
            historyManager.entries.remove(at: index)
        }
    }
}


import Foundation

extension Array where Element == HistoryEntry {
    func groupedByDay() -> [HistoryEntry] {
        var groupedEntries: [Date: HistoryEntry] = [:]

        let calendar = Calendar.current
        for entry in self {
            let day = calendar.startOfDay(for: entry.timestamp) // Get the start of the day
            if groupedEntries[day] == nil {
                groupedEntries[day] = entry // Take the first entry of the day
            }
        }
        return groupedEntries.values.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    func groupedByMinute() -> [Date: [HistoryEntry]] {
        var groupedEntries: [Date: [HistoryEntry]] = [:]
        let calendar = Calendar.current

        for entry in self {
            // Normalize the timestamp to the start of the minute
            if let minute = calendar.date(bySetting: .second, value: 0, of: entry.timestamp) {
                groupedEntries[minute, default: []].append(entry)
            }
        }
        return groupedEntries
    }
    
    func firstEntryGroupedByMinute() -> [HistoryEntry] {
        let groupedEntries = self.groupedByMinute()
        return groupedEntries.values.compactMap { $0.first }
    }
}
