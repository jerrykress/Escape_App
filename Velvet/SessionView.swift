//
//  SessionView.swift
//  Velvet
//
//  Created by Jerry Kress on 09/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage

struct SessionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                //Backgroud
                Color.black
                
                //Sleep Button
                Button(action: {
                    print("Stop Button Pressed")
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Image(systemName: "stop.fill")
                    .foregroundColor(.white)
                }
                .buttonStyle(BlurryRoundButtonStyle())
                .frame(width: 0, height: 580, alignment: .bottom)
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        .navigationBarBackButtonHidden(true) //Disable Back Swipe Gesture
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //Larger Screen Preview
            SessionView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            //Standard Screen Preview
            SessionView()
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }
    }
}
