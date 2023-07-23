//
//  WebAPI.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import Foundation
import Combine

struct IPGeolocationResultFree: Codable {
    let IP: String
    let countryCode: String
    let countryName: String
    let regionName: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let zipCode: String
    let timeZone: String
    let asn: String
    let AS: String
    let isProxy: Bool
    
    // Define custom coding keys to handle snake_case keys in JSON
    private enum CodingKeys: String, CodingKey {
        case IP = "ip"
        case countryCode = "country_code"
        case countryName = "country_name"
        case regionName = "region_name"
        case cityName = "city_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case zipCode = "zip_code"
        case timeZone = "time_zone"
        case asn = "asn"
        case AS = "as"
        case isProxy = "is_proxy"
    }
}

struct IPGeolocationResult: Codable {
    let IP: String
    let countryCode: String
    let countryName: String
    let regionName: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let zipCode: String
    let timeZone: String
    let asn: String
    let AS: String
    let isp: String
    let domain: String
    let netSpeed: String
    let iddCode: String
    let areaCode: String
    let weatherStationCode: String
    let weatherStationName: String
    let mcc: String
    let mnc: String
    let mobileBrand: String
    let elevation: Int
    let usageType: String
    let addressType: String
    let continent: Continent
    let district: String
    let country: Country
    let region: Region
    let city: City
    let timeZoneInfo: TimeZoneInfo
    let geotargeting: Geotargeting
    let adsCategory: String
    let adsCategoryName: String
    let isProxy: Bool
    let proxy: Proxy
}

struct Continent: Codable {
    let name: String
    let code: String
    let hemisphere: [String]
    let translation: Translation
}

struct Translation: Codable {
    let lang: String
    let value: String
}

struct Country: Codable {
    let name: String
    let alpha3Code: String
    let numericCode: Int
    let demonym: String
    let flag: String
    let capital: String
    let totalArea: Int
    let population: Int
    let currency: Currency
    let language: Language
    let tld: String
    let translation: Translation
}

struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String
}

struct Language: Codable {
    let code: String
    let name: String
}

struct Region: Codable {
    let name: String
    let code: String
    let translation: Translation
}

struct City: Codable {
    let name: String
    let translation: Translation
}

struct TimeZoneInfo: Codable {
    let olson: String
    let currentTime: String
    let gmtOffset: Int
    let isDst: Bool
    let sunrise: String
    let sunset: String
}

struct Geotargeting: Codable {
    let metro: String
}

struct Proxy: Codable {
    let lastSeen: Int
    let proxyType: String
    let threat: String
    let provider: String
}

struct IPGeolocationError: Codable {
    let error: ErrorInfo
}

struct ErrorInfo: Codable {
    let errorCode: Int
    let errorMessage: String
}

// The IPGeolocation class; The main wrapper arround the IP2Location.io Web API.
class IPGeolocation {
    private let apiKey: String?
    let baseUrl = "api.ip2location.io"

    init(apiKey: String?) {
        self.apiKey = apiKey
    }

    func lookUp(ip: String?) -> AnyPublisher<IPGeolocationResultFree, Error> {
        guard let apiKey = self.apiKey else {
            return Fail(error: NSError(domain: "No API key", code: 0)).eraseToAnyPublisher()
        }
        
        // &lang=\(lang) only available for security and plus plan
        var urlString = "https://\(baseUrl)/?key=\(apiKey)&format=json"
        if let ipAddr = ip {
            urlString += "&ip=\(ipAddr)"
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "Error HTTP \(response)", code: 0, userInfo: nil)
                }
                return data
            }
            .decode(type: IPGeolocationResultFree.self, decoder: JSONDecoder())
            .mapError { error in
                error as Error
            }
            .eraseToAnyPublisher()
    }
}


/*
// Usage example:
let config = Configuration(apiKey: "YOUR_API_KEY", source: "YOUR_SOURCE", sourceVersion: "YOUR_SOURCE_VERSION")
let ipGeolocation = IPGeolocation(config: config)
ipGeolocation.lookUp(ip: "8.8.8.8", lang: "en") { result in
    switch result {
    case .success(let geolocationResult):
        print(geolocationResult)
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
*/
