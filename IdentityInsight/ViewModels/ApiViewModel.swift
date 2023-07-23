//
//  Backend.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import Foundation
import Combine
import MapKit

struct MyAnnotation: Identifiable {
    let id: UUID = UUID()
    let lat: Double
    let long: Double
}

@MainActor
class ApiViewModel: ObservableObject {
    private let webApi: IPGeolocation = IPGeolocation(apiKey: Bundle.main.infoDictionary?["API_KEY"] as? String)
    private var cancellables = Set<AnyCancellable>()
    private var isPreview: Bool = false
    
    @Published var response: IPGeolocationResultFree?
    @Published var coordRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    @Published var annotations: [MyAnnotation] = []
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
    }
    
    func refresh() {
        if isPreview {
            return
        }
        
        if !cancellables.isEmpty {
            cancellables.forEach { cancellable in
                cancellable.cancel()
            }
        }
        
        if isPresentationMode() {
            DispatchQueue.main.async {
                let result = presentationModeResponses[getPresentationModeResponseIndex()]
                self.response = result
                self.coordRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                self.annotations = [MyAnnotation(lat: result.latitude, long: result.longitude)]
            }
            return
        }
        
        webApi.lookUp(ip: nil)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error requesting api: \(error.localizedDescription)")
                }
            }, receiveValue: { result in
                self.response = result
                self.coordRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
                self.annotations = [MyAnnotation(lat: result.latitude, long: result.longitude)]
            })
            .store(in: &cancellables)
    }
}
