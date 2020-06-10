//
//  SessionView.swift
//  Velvet
//
//  Created by Jerry Kress on 09/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct SessionView: View {
    var action: (() -> Void)?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                //Backgroud
                LinearGradient(Color.darkStart, Color.darkEnd)
                
                //Sleep Button
                Button(action: {
                    print("Stop Button Pressed")
                    
                }) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(NeumorphicButtonStyle())
                .frame(width: 0, height: 580, alignment: .bottom)
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }
        //End of Body
    }
    
    public func onAction(action: @escaping () -> Void) -> SessionView {
        var view = self
        view.action = action
        return view
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
