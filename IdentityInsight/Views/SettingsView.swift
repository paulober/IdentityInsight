//
//  SettingsView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Identity Insight is using IP2Location.io ") +
                    Text((try! AttributedString(markdown: "[IP geolocation](https://www.ip2location.io)"))) +
                    Text(" web service.")
                } header: {
                    Text("Credits (Tech-Stack)")
                }
                
                Section {
                    Text("https://wallpapers.com/wallpapers/4k-nature-iphone-j5ri2ltmc5ibbuj9.html")
                    Text("https://wallpapers.com/wallpapers/4k-nature-iphone-mcbj1b2wjm22yw1k.html")
                    Text("https://wallpapers.com/wallpapers/4k-nature-iphone-otzcqpe10xs5zw9c.html")
                    Text("https://wallpapers.com/wallpapers/4k-nature-iphone-4octteytu72882ak.html")
                    Text("https://wallpapers.com/wallpapers/4k-nature-iphone-ixm6rkj673rxbvus.html")
                } header: {
                    Text("Credits (Images)")
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/paulober/IdentityInsight")!,
                         label: {
                        Label("Star on GitHub", systemImage: "link")
                    })
                }
            }
            .navigationTitle("Settings")
        }
    }
}
