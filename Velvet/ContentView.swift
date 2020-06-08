//
//  ContentView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import SwiftUIPager


let urls: [String] = ["https://i.pinimg.com/564x/ed/eb/59/edeb59cd554c95645fbca777424e3c3c.jpg",
                      "https://i.pinimg.com/564x/75/13/15/751315b619ee2f307cfba9b0dcbf7446.jpg",
                      "https://i.pinimg.com/564x/50/e7/6e/50e76edb2155f5dec0a2485ad8c0a1e9.jpg"]


extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}


extension LinearGradient {
    init(_ colors : Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 3))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)

            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 3))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}


struct neumorphicButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(30)
        .contentShape(Circle())
        .background(
            DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
        .animation(nil)
    }
}


struct ContentView: View {
    @State var page1: Int = 0
    @State var data1 = Array(0..<5)
    @State var isPresented: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
    //          Backgroud
                LinearGradient(Color.darkStart, Color.darkEnd)
                
                Pager(page: self.$page1,
                      data: self.data1,
                      id: \.self) {
                        self.pageView($0)
                }
                .loopPages()
                .itemSpacing(10)
                .itemAspectRatio(0, alignment: .start)
                .offset(x: 0, y: 210 - proxy.size.height/2)
                .frame(width: proxy.size.width, height: 550, alignment: .top)
//                .mask(
//                    Circle()
//                        .fill(LinearGradient(Color.darkEnd, Color.darkStart))
//                        .offset(x: 0, y: -250)
//                        .frame(width: 1000, height: 1000, alignment: .center)
//                )
                
                
    //            Sleep Button
                Button(action: {
                    print("Sleep Button Pressed")
                    
                }) {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(neumorphicButtonStyle())
                .frame(width: 0, height: 580, alignment: .bottom)
                
            }
            .edgesIgnoringSafeArea(.all)
            
        }
//        End of Body
    }
    
    func pageView(_ page: Int) -> some View {
        GeometryReader { proxy in
            ZStack {
                Image("dunes")
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: 550, alignment: .top)
    //            Text("Page: \(page)")
    //                .bold()
            }
            .cornerRadius(10)
            .shadow(radius: 5)
        
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone XS Max")
    }
}
