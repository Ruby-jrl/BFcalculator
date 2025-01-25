//
//  historyTracking.swift
//  BFcalculator
//
//  Created by Ruby Liu on 24/01/2025.
//

import Foundation


// data model
struct HistoryEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let bodyFatPercentage: Double
    let method: String
}


// storage mechanism
public class HistoryManager: ObservableObject {
    @Published var entries: [HistoryEntry] = []
    
    private let historyKey = "historyEntries"

    init() {
        loadHistory()
    }

    func addEntry(_ entry: HistoryEntry) {
        entries.append(entry)
        saveHistory()
    }
    
    func clearHistory() {
        entries.removeAll()
        saveHistory()
    }

    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            entries = decoded
        }
    }
}



// next step: add session or user ID to history
