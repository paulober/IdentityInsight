//
//  PresentationModeHelper.swift
//  IdentityInsight
//
//  Created by Paul on 23.07.23.
//

import Foundation

func isPresentationMode() -> Bool {
    if let value = ProcessInfo.processInfo.environment["PRESENTATION_MODE"] {
        return value.lowercased() == "true"
    }
    
    return false
}

func getPresentationModeResponseIndex() -> Int {
    if let value = ProcessInfo.processInfo.environment["PRESENTATION_MODE_RESPONSE"] {
        return Int(value.lowercased()) ?? 0
    }
    
    return 0
}

let presentationModeResponses: [IPGeolocationResultFree] = [
    IPGeolocationResultFree(
        IP: "1.1.1.1",
        countryCode: "US",
        countryName: "United States of America",
        regionName: "California",
        cityName: "Cupertino",
        latitude: 37.334873,
        longitude: -122.006090,
        zipCode: "95014",
        timeZone: "-07:00",
        asn: "123",
        AS: "Imaginary Communications",
        isProxy: true
    ),
    IPGeolocationResultFree(
        IP: "2.2.2.2",
        countryCode: "CA",
        countryName: "Canada",
        regionName: "British Columbia",
        cityName: "Vancouver",
        latitude: 49.260413,
        longitude: -123.113946,
        zipCode: "12345",
        timeZone: "-07:00",
        asn: "321",
        AS: "Internet.org",
        isProxy: true
    )
]
