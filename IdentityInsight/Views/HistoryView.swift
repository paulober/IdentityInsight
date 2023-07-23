//
//  HistoryView.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

import SwiftUI
import MapKit

struct HistoryView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    
    var body: some View {
        if let historyItems = viewModel.history?.items {
            if let calculatedRegion = viewModel.history?.boundingRegion() {
                Map(
                    coordinateRegion: .constant(calculatedRegion),
                    interactionModes: .all,
                    showsUserLocation: false,
                    userTrackingMode: .constant(.none),
                    annotationItems: historyItems) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        VStack {
                            Text("\(item.provider) | \(emojiFlag(for: item.country))")
                                .padding(4)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                        }
                    }
                }
                .edgesIgnoringSafeArea([.top, .horizontal])
            } else {
                Text("No history available.")
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
