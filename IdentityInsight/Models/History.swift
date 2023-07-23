//
//  HistoryBackend.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

import Foundation
import MapKit

struct HistoryItem: Identifiable, Codable {
    let id: Int
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
    let provider: String
    let country: String
    
    init(lat: CLLocationDegrees, long: CLLocationDegrees, provider: String, country: String) {
        self.lat = lat
        self.long = long
        self.provider = provider
        self.country = country
        
        // calculate the hash value using all properties of the Item
        var hasher = Hasher()
        hasher.combine(lat)
        hasher.combine(long)
        hasher.combine(provider)
        hasher.combine(country)
        self.id = hasher.finalize()
    }
}

struct History: Codable {
    var items: [HistoryItem]
    
    // Function to save the History object as a binary plist
    func saveHistory() {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        do {
            let data = try encoder.encode(self)
            try data.write(to: Self.getHistoryFileURL(), options: .atomic)
        } catch {
            print("Error saving history: \(error)")
        }
    }
    
    // Function to load the History object from a binary plist
    static func loadHistory() -> History {
        guard let data = try? Data(contentsOf: getHistoryFileURL()) else {
            return History(items: [])
        }
        
        let decoder = PropertyListDecoder()
        do {
            let history = try decoder.decode(History.self, from: data)
            return history
        } catch {
            print("Error loading history: \(error)")
            return History(items: [])
        }
    }
    
    // Helper function to get the file URL for saving/loading the plist
    private static func getHistoryFileURL() -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Error getting documents directory.")
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("History.plist")
        return fileURL
    }
    
    func boundingRegion() -> MKCoordinateRegion? {
        guard !items.isEmpty else {
            return nil
        }

        // Initialize min and max latitude and longitude
        var minLat = items[0].lat
        var maxLat = items[0].lat
        var minLong = items[0].long
        var maxLong = items[0].long

        // Find the min and max latitude and longitude
        for item in items {
            minLat = min(minLat, item.lat)
            maxLat = max(maxLat, item.lat)
            minLong = min(minLong, item.long)
            maxLong = max(maxLong, item.long)
        }

        // Calculate the center coordinate
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2)

        // Calculate the span
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.2, longitudeDelta: (maxLong - minLong) * 1.2)

        return MKCoordinateRegion(center: center, span: span)
    }
}


