//
//  ContentView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import SwiftUIPager
import URLImage

let img = "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg"
let url = URL(string: img)

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
                            .opacity(0.8)
                    }
                    .buttonStyle(BlurryRoundButtonStyle())
                    .frame(width: 0, height: 500, alignment: .bottom)
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
                 URLImage(url!,
                          content: {
                              $0.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height/1.1, alignment: .top)
                          })
                
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
