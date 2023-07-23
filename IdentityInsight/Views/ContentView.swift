//
//  ContentView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var backend = Backend()
    
    var body: some View {
        TabView {
            IdentityView()
                .tabItem {
                    Label("ID", systemImage: "touchid")
                }
                .environmentObject(backend)
                .edgesIgnoringSafeArea([.horizontal, .top])
            
            WikiPagesView()
                .tabItem {
                    Label("More details", systemImage: "book")
                }
            
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
