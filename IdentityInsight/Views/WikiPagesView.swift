//
//  WikiPagesView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct WikiPagesView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text(
                        "Your IPs' fingerprint can be used on serveral different ways to track you internet activity:\n- In combination with other application data like in a browser some browser based context to create a unique fingerprint that lets the service identify your activity and connect them to you.\n- The IP alone or if only one device from this region and internet service provider (ISP) combination access the service.\n\nIt's imporant to know what your current digital address unvails to other actors in the internet publicly when accessing a service."
                    )
                }
                .padding()
            }
            .navigationTitle("Details")
        }
    }
}
