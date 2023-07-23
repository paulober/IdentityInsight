//
//  IdentityDetailsView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct IdentityDetailsView: View {
    @EnvironmentObject var backend: Backend
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        if let response = backend.response {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // verticaly layout
                VStack {
                    List {
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text(emojiFlag(for: response.countryCode))
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Region:")
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(response.cityName)
                                }
                                HStack {
                                    Spacer()
                                    Text(response.regionName)
                                }                            }
                            .alignmentGuide(.trailing) { d in
                                return d[.trailing]
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Timezone:")
                            Spacer()
                            Text("UTC\(response.timeZone)")
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Provider:")
                            Spacer()
                            Text(response.AS == "" ? response.asn : response.AS)
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("IP:")
                            Spacer()
                            Text(response.IP)
                            
                            Button(action: {
                                UIPasteboard.general.string = response.IP
                            }, label: {
                                Image(systemName: "doc.on.doc")
                            })
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        VStack {
                            Text("In many regions, it's common for the location displayed to be approximately 10 to 50 kilometers or more away from your actual physical location.\nThis happens because the location shown is where your traffic exits your internet provider's network.\nConsequently, many others in your area will share a similar digital address fingerprint (but with a different IP address), even though their actual locations differ.")
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    //.scrollDisabled(true)
                }
            } else {
                // horizontal two column layout
                HStack {
                    List {
                        HStack {
                            Text("Country:")
                            Spacer()
                            Text(emojiFlag(for: response.countryCode))
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Region:")
                            Spacer()
                            VStack {
                                HStack {
                                    Spacer()
                                    Text(response.cityName)
                                }
                                HStack {
                                    Spacer()
                                    Text(response.regionName)
                                }
                            }
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Timezone:")
                            Spacer()
                            Text("UTC\(response.timeZone)")
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("Provider:")
                            Spacer()
                            Text(response.AS == "" ? response.asn : response.AS)
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        HStack {
                            Text("IP:")
                            Spacer()
                            Text(response.IP + " ")
                            
                            Button(action: {
                                UIPasteboard.general.string = response.IP
                            }, label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            })
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        VStack {
                            Text("This is what your digital address reveals to others on the internet about you.\nYou might wonder how to change or conceal it.\nHowever, you cannot alter these specific details since they are not directly sourced from you.\nYet, you have the option to change or mask your digital address (IP) as a protective measure.\nThis can be achieved through VPNs or special proxies, which function similarly to postal boxes in the physical world.\nIn many regions, it's common for the location displayed to be approximately 10 to 50 kilometers or more away from your actual physical location.\nThis happens because the location shown is where your traffic exits your internet provider's network.\nConsequently, many others in your area will share a similar digital address fingerprint, even though their actual locations differ.")
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                }
            }
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
    
    func emojiFlag(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var flagString = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scalar = UnicodeScalar(base + $0.value) {
                flagString.append(String(scalar))
            }
        }
        return flagString
    }
}

struct IdentityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var backend = Backend(isPreview: true)
        IdentityDetailsView()
            .environmentObject(backend)
    }
}