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
                    Label(NSLocalizedString("MAIN_TAB_VIEW_ITEM_ID", comment: ""), systemImage: "touchid")
                }
                .environmentObject(backend)
                .edgesIgnoringSafeArea([.horizontal, .top])
            
            HistoryView()
                .tabItem {
                    Label(NSLocalizedString("MAIN_TAB_VIEW_ITEM_HISTORY", comment: ""), systemImage: "clock.arrow.circlepath")
                }
                .edgesIgnoringSafeArea([.horizontal, .top])
            
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("MAIN_TAB_VIEW_ITEM_SETTINGS", comment: ""), systemImage: "gear")
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
