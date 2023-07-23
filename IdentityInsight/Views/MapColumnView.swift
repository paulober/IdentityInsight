//
//  MapColumn.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import Foundation
import SwiftUI
import MapKit

let figureSymbolStates: [String] = ["run", "roll", "american.football", "archery", "australian.football", "badminton", "baseball", "basketball", "bowling", "boxing", "climbing", "cooldown", "core.training", "cricket", "skiing.crosscountry", "cross.training", "curling", "disc.sports", "skiing.downhill", "elliptical", "fencing", "fishing", "flexibility", "strengthtraining.functional", "golf", "hand.cycling", "handball", "hiking", "hockey", "hunting", "indoor.cycle", "kickboxing", "lacrosse", "martial.arts", "mind.and.body", "open.water.swim", "outdoor.cycle", "pickleball", "racquetball", "rolling", "rower", "rugby", "sailing", "skating", "snowboarding", "soccer", "softball", "squash", "surfing", "table.tennis", "tennis", "strengthtraining.traditional", "volleyball", "water.fitness", "waterpolo"]
let figureName = "figure." + (figureSymbolStates.randomElement() ?? "fishing")

struct MapColumnView: View {
    @EnvironmentObject var backend: Backend
    
    var body: some View {
        if backend.response != nil {
            ZStack(alignment: .bottomTrailing) {
                // todo use UserAnnotation in 17.0+
            
                // [Workaround] AnyView as Wrapper so no "opaque return type error" if uysing return
                Map(
                    // .constant because zoom would cause lots of "Publishing changes
                    // from within view updates is not allowed" errors
                    coordinateRegion: .constant(backend.coordRegion),
                    interactionModes: .all,
                    showsUserLocation: false,
                    userTrackingMode: .constant(.none),
                    annotationItems: backend.annotations
                ) { annotation in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.long)) {
                        Image(systemName: figureName)
                            .imageScale(.large)
                            .foregroundColor(.orange)
                            .padding(2)
                            .background(Circle().fill(.ultraThinMaterial))
                    }
                }
                .disabled(true)
                
                Button(action: {
                    
                }) {
                    Label("Save", systemImage: "square.and.arrow.down")
                        .tint(.orange)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                .padding(8) // Adjust the padding as needed
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}

struct MapColumnView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var backend = Backend(isPreview: true)
        MapColumnView()
            .environmentObject(backend)
    }
}
