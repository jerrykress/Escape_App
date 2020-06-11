//
//  ContentView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import SwiftUIPager


//Custom Mask for Pager View
let dome = Path { p in
    p.move(to: CGPoint(x: 0, y: 0))
    p.addLine(to: CGPoint(x: 0, y: 250))
    p.addCurve(to: CGPoint(x: 100, y: 250),
               control1: CGPoint(x: 25, y: 215),
               control2: CGPoint(x: 75, y: 215))
    p.addLine(to: CGPoint(x: 100, y: 0))
    p.addLine(to: CGPoint(x: 0, y: 0))
}


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


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


struct PathToShape: Shape {
    let path: Path
    
    func path(in rect: CGRect) -> Path {
        let bounds = path.boundingRect
        return path.applying(
            CGAffineTransform(scaleX: rect.size.width/bounds.size.width, y: rect.size.height/bounds.size.height)
        )
    }
}


struct ContentView: View {
    @State var page1: Int = 0
    @State var data1 = Array(0..<5)
    
    var body: some View {
            
        NavigationView {
                    
            GeometryReader { proxy in
                
                ZStack {
                    //Backgroud
                    LinearGradient(Color.darkStart, Color.darkEnd)
                    
                    Group {
                        Pager(page: self.$page1,
                              data: self.data1,
                              id: \.self) {
                                self.pageView($0)
                        }
                        .loopPages()
                        .interactive(0.9)
                        .itemSpacing(10)
                        .itemAspectRatio(0, alignment: .center)
                        .offset(x: 0, y: 0)
                        .frame(width: proxy.size.width, height: proxy.size.height*1.2, alignment: .center)
                    }
                    .shadow(color: Color.darkEnd, radius: 10, x: 15, y: 12)
                    
                    //Sleep Button
                    NavigationLink(destination: SessionView()){
                        Image(systemName: "moon.fill")
                        .foregroundColor(.white)
                            .opacity(0.9)
                    }
                    .buttonStyle(BlurryRoundButtonStyle())
                    .frame(width: 0, height: 580, alignment: .bottom)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
        //End of Body
    }
    
    func pageView(_ page: Int) -> some View {
        GeometryReader { proxy in
            ZStack {
                Image("forest")
                .resizable()
                .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height/1.1, alignment: .top)
                
//                Text("Page: \(page)")
//                    .bold()
            }
            .cornerRadius(10)
            .shadow(radius: 5)
        
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //Larger Screen Preview
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            //Standard Screen Preview
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }
    }
}
