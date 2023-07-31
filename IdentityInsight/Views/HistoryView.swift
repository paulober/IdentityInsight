//
//  HistoryView.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

import SwiftUI
import MapKit

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

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
                        ZStack {
                            VStack {
                                Text("\(item.provider) | \(emojiFlag(for: item.country))")
                                    .padding(4)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
                            }
                            
                            Triangle()
                                .foregroundColor(Color.clear)
                                .background(Triangle().fill(.ultraThinMaterial))
                                .frame(width: 20, height: 10)
                                .rotationEffect(Angle(degrees: 180))
                                .offset(y: 18)
                        }
                    }
                }
                .edgesIgnoringSafeArea([.top, .horizontal])
            } else {
                Text(NSLocalizedString("HISTORY_VIEW_NO_HISTORY", comment: ""))
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
