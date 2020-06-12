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


struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var page1: Int = 0
    @State var data1 = Array(0..<3)
    
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
                    .frame(width: 0, height: 600, alignment: .bottom)
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
                //Background
                URLImage(URL(string: self.userData.allScenes[page].coverURL)!,
                         expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                         content: {
                              $0.image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height/1.1, alignment: .top)
                         })
                
                VStack {
                    //Sound Title
                    Text(self.userData.allScenes[page].title)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .opacity(0.9)
                        .padding(10)
                    
                    //Sound Description
                    Text(self.userData.allScenes[page].description)
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                        .opacity(0.9)
                }
                .frame(width: proxy.size.width, height: proxy.size.height/1.5, alignment: .top)
                
            }
            .cornerRadius(10)
            .shadow(radius: 5)
        
        }
    }
}


#if DEBUG

var mockData = UserData()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //Standard Screen Preview
            ContentView().environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }
    }
}

#endif
