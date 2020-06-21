//
//  Playground.swift
//  Velvet
//
//  Created by Jerry Kress on 14/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import Foundation
import SwiftUI

struct Playground: View {
    // 1.
    @State var circleColor = Color.yellow
    @State var value: Double = 30
    let background = Color(red: 0.07, green: 0.07, blue: 0.12)
    
    var body: some View {

        VStack{
            
            CustomSlider(value: $value,   range: (0, 100)) { modifiers in
              ZStack {
                LinearGradient(gradient: .init(colors: [Color.pink, Color.orange ]), startPoint: .leading, endPoint: .trailing)
                ZStack {
                  Circle().fill(Color.white)
                  Circle().stroke(Color.black.opacity(0.2), lineWidth: 2)
                  Text(("\(Int(self.value))")).font(.system(size: 11))
                }
                .padding([.top, .bottom], 2)
                .modifier(modifiers.knob)
              }.cornerRadius(15)
            }.frame(height: 30)
            
            

            CustomSlider(value: $value, range: (0, 100), knobWidth: 0) { modifiers in
              ZStack {
                
                LinearGradient(gradient: .init(colors: [self.background, Color.black.opacity(0.6) ]), startPoint: .bottom, endPoint: .top)

                Group {
                  LinearGradient(gradient: .init(colors: [Color.blue, Color.purple, Color.pink ]), startPoint: .leading, endPoint: .trailing)
                    LinearGradient(gradient: .init(colors: [Color.clear, self.background]), startPoint: .top, endPoint: .bottom).opacity(0.15)
                }.modifier(modifiers.barLeft)
                
                Text("Custom Slider").foregroundColor(.white)
              }
              .cornerRadius(8)
            }
            .frame(height: 40)
            .padding(2)
            .background(
              // adds shadow border around entire slider (to make it appear inset)
              LinearGradient(gradient: .init(colors: [Color.gray, Color.black ]), startPoint: .bottom, endPoint: .top)
              .opacity(0.2)
              .cornerRadius(9)
            )
            
        }
    
    }
}

struct Playground_Previews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
