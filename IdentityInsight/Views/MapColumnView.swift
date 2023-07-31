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
    @EnvironmentObject var backend: ApiViewModel
    @EnvironmentObject var historyViewModel: HistoryViewModel
    @State var showAlert: Bool = false
    @State var alertError: String?
    
    var body: some View {
        if backend.response != nil && !backend.annotations.isEmpty {
            ZStack(alignment: .bottomTrailing) {
                // todo use UserAnnotation in 17.0+
            
                // [Workaround] AnyView as Wrapper so no "opaque return type error" if uysing return
                // Causes: "[SwiftUI] Publishing changes from within view updates is not allowed, this will cause undefined behavior." error on view updates like user interacting witrh map or the button press. Unsolved by Apple...
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
                            .padding(4)
                            .background(Circle().fill(.ultraThickMaterial))
                            .shadow(radius: 5)
                    }
                }
                .disabled(true)
                
                Button(action: {
                    if let lat = backend.annotations.first?.lat,
                       let long = backend.annotations.first?.long,
                       let provider = backend.response?.AS,
                       let countryCode = backend.response?.countryCode {
                        let newHistoryItem = HistoryItem(lat: lat, long: long, provider: provider, country: countryCode)
                        if (historyViewModel.history?.items.contains(where: { $0.id == newHistoryItem.id }) ?? false) {
                            DispatchQueue.main.async {
                                alertError = NSLocalizedString("ERRORS_LOCATION_ALREADY_IN_HISTORY", comment: "")
                                showAlert = true
                            }
                            return
                        } else {
                            if !historyViewModel.storeNewItem(newHistoryItem) {
                                DispatchQueue.main.async {
                                    alertError = NSLocalizedString("ERRORS_ADD_LOCATION_FAILED", comment: "")
                                    showAlert = true
                                }
                                return
                            }
                        }
                    }
                }) {
                    Label(NSLocalizedString("MAP_COLUMN_VIEW_SAVE_BUTTON", comment: ""), systemImage: "square.and.arrow.down")
                        .tint(.orange)
                }
                .padding(11)
                .background(RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial))
                .padding(6)
            }
            .alert("Error adding item to history", isPresented: $showAlert) {
                Button("Ok") {
                    DispatchQueue.main.async {
                        showAlert = false
                    }
                }
            } message: {
                Text(alertError ?? "Unknown error")
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}

struct MapColumnView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var backend = ApiViewModel(isPreview: true)
        @StateObject var historyViewModel = HistoryViewModel()
        MapColumnView()
            .environmentObject(backend)
            .environmentObject(historyViewModel)
    }
}
