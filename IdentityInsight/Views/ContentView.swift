//
//  ContentView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var backend = ApiViewModel()
    
    var body: some View {
        TabView {
            IdentityView()
                .tabItem {
                    Label("ID", systemImage: "touchid")
                }
                .environmentObject(backend)
                .edgesIgnoringSafeArea([.horizontal, .top])
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .edgesIgnoringSafeArea([.horizontal, .top])
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear {
            self.backend.refresh()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
