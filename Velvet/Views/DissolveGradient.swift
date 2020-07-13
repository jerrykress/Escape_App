//
//  DissolveGradient.swift
//  Velvet
//
//  Created by Jerry Kress on 06/07/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage


struct DissolveGradient: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            ForEach(Array(0..<self.userData.getAllScene().count), id: \.self) { imgIndex in
                URLImage(URL(string: self.userData.getSceneByIndex(index: imgIndex).coverURL)!,
                         expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                         content: {
                              $0.image
                                .resizable()
                         }
                )
                .opacity(self.userData.currentTrackIndex == imgIndex ? 1 : 0)
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .light))
            
        }
        .animation(Animation.easeInOut.speed(0.25))
    }
}
 
struct DissolveGradient_Previews: PreviewProvider {
    static var previews: some View {
        DissolveGradient()
    }
}
