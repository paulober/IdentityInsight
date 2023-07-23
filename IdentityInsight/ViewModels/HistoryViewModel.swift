//
//  HistoryViewModel.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var history: History?
    
    init() {
        loadHistoryInBackground()
    }
    
    public func storeNewItem(_ item: HistoryItem) -> Bool {
        // this should never happen
        if history == nil {
            return false
        }
        
        DispatchQueue.main.async {
            self.history?.items.append(item)
            self.saveHistoryInTheBackground()
        }
        
        return true
    }
    
    private func saveHistoryInTheBackground() {
        DispatchQueue.global(qos: .background).async {
            self.history?.saveHistory()
        }
    }
    
    private func loadHistoryInBackground() {
        DispatchQueue.global(qos: .background).async {
            // load the history data in the background then add in main
            let loadedHistory = History.loadHistory()
            DispatchQueue.main.async {
                self.history = loadedHistory
            }
        }
    }
}
