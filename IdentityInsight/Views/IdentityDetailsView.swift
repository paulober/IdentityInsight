//
//  IdentityDetailsView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

struct IdentityDetailsView: View {
    @EnvironmentObject var backend: ApiViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @State var isExplanationExpanded = false
    
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
                        
                        DisclosureGroup(isExpanded: $isExplanationExpanded) {
                            VStack {
                                Text("In many regions, it's common for the location displayed to be approximately 10 to 50 kilometers or more away from your actual physical location.\nThis happens because the location shown is where your traffic exits your internet provider's network.\nConsequently, many others in your area will share a similar digital address fingerprint (but with a different IP address), even though their actual locations differ.")
                            }
                        } label: {
                            Text("Explanation")
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
                                Image(systemName: "doc.on.doc")
                            })
                        }
                        .accessibilityElement(children: .combine)
                        .listRowBackground(Color.clear)
                        
                        VStack {
                            Text("In many regions, it's common for the location displayed to be approximately 10 to 50 kilometers or more away from your actual physical location.\nThis happens because the location shown is where your traffic exits your internet provider's network.\nConsequently, many others in your area will share a similar digital address fingerprint, even though their actual locations differ.")
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
}

struct IdentityDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var backend = ApiViewModel(isPreview: true)
        IdentityDetailsView()
            .environmentObject(backend)
    }
}
