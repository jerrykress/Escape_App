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
    
    @FetchRequest(
        entity: SoundSceneData.entity(),
        sortDescriptors: []
    ) var soundSceneData: FetchedResults<SoundSceneData>
    
    var body: some View {
        ZStack {
            ForEach(Array(0..<self.userData.getAllScene().count), id: \.self) { imgIndex in
                Image(self.userData.getSceneByIndex(index: imgIndex).coverURL)
                    .resizable()
                    .opacity(self.userData.currentTrackIndex == imgIndex ? 1 : 0)
            }
            
            VisualEffectView(effect: UIBlurEffect(style: .dark))
            
        }
        .animation(Animation.easeInOut.speed(0.25))
    }
}
 
struct DissolveGradient_Previews: PreviewProvider {
    static var previews: some View {
        DissolveGradient()
    }
}
