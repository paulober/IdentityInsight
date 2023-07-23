//
//  IdentityView.swift
//  IdentityInsight
//
//  Created by Paul on 20.07.23.
//

import SwiftUI

let backgroundImages: [String] = ["4k-nature-iphone-j5ri2ltmc5ibbuj9", "4k-nature-iphone-mcbj1b2wjm22yw1k", "4k-nature-iphone-otzcqpe10xs5zw9c", "4k-nature-iphone-4octteytu72882ak", "4k-nature-iphone-ixm6rkj673rxbvus"]
let backgroundImage = backgroundImages.randomElement() ?? "4k-nature-iphone-j5ri2ltmc5ibbuj9"

struct IdentityView: View {
    @EnvironmentObject var backend: ApiViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        GeometryReader { geometry in
            Image(backgroundImage)
                .resizable()
                .edgesIgnoringSafeArea([.horizontal, .top])
                .clipped()
                .blur(radius: 2)
            
            let width75 = geometry.size.width * 0.75
            let widthOther = geometry.size.width - width75
            let height75 = geometry.size.height * 0.75
            let heightOther = geometry.size.height - height75
            
            let mapPortion = 0.35
            let detailsPortion = 0.65
            
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                VStack {
                    MapColumnView()
                        .frame(width: width75, height: height75 * mapPortion)
                        .alignmentGuide(.top) { d in
                            return d[.top]
                        }
                        .cornerRadius(16)
                        // for debuging
                        //.background(Color.blue)
                    
                    IdentityDetailsView()
                        .frame(width: width75, height: height75 * detailsPortion)
                        .alignmentGuide(.bottom) { d in
                            return d[.bottom]
                        }
                        .cornerRadius(16)
                        // for debuging
                        //.background(Color.red)
                }
                .frame(width: width75, height: height75)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .offset(x: widthOther/2, y: heightOther/2)
            } else {
                HStack {
                    MapColumnView()
                        .frame(width: width75 * mapPortion, height: height75)
                        .alignmentGuide(.leading) { d in
                            return d[.leading]
                        }
                        .cornerRadius(16)
                    
                    IdentityDetailsView()
                        .frame(width: width75 * detailsPortion, height: height75)
                        .alignmentGuide(.trailing) { d in
                            return d[.trailing]
                        }
                        .cornerRadius(16)
                }
                .frame(width: width75, height: height75)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .offset(x: widthOther/2, y: heightOther/2)
            }
        }
    }
    
    func orientationToDegres() -> Double {
        switch UIDevice.current.orientation {
        case .portrait:
            return 0
        case .landscapeLeft:
            return -90
        case .landscapeRight:
            return 90
        default:
            return 0
        }
    }
}

struct IdentityView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var backend = ApiViewModel(isPreview: true)
        IdentityView()
            .environmentObject(backend)
    }
}
