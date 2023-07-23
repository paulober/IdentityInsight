//
//  IdentityInsightApp.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

@main
struct IdentityInsightApp: App {
    @StateObject private var historyViewModel = HistoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyViewModel)
        }
    }
}
