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
    @State var isSessionViewPresented: Bool = false
    
    var body: some View {
            
        // MARK: Home View
        GeometryReader { proxy in
            
            ZStack {
                //Backgroud
                LinearGradient(Color.darkStart, Color.darkEnd)
                
                Group {
                    Pager(page: self.$userData.currentTrackIndex,
                          data: self.userData.idx,
                          id: \.self) {
                            self.pageView($0)
                    }
                    .loopPages()
                    .interactive(0.9)
                    .itemSpacing(10)
                    .itemAspectRatio(0, alignment: .center)
                    .offset(x: 0, y: 0)
                    .frame(width: proxy.size.width, height: proxy.size.height * 1.2, alignment: .center)
                }
                .shadow(color: Color.darkEnd, radius: 10, x: 15, y: 12)
                
                //Sleep Button
                Button(action: {
                    withAnimation {
                        self.isSessionViewPresented.toggle()
                    }
                }){
                    Image(systemName: "moon.fill")
                    .foregroundColor(.white)
                        .opacity(0.8)
                }
                .buttonStyle(BlurryRoundButtonStyle())
                .frame(width: 0, height: 600, alignment: .bottom)
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom, alignment: .center)
            .edgesIgnoringSafeArea(.all)
            
            // MARK: Session View
            if(self.isSessionViewPresented) {
                SessionView(isSessionViewPresented: self.$isSessionViewPresented)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
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
                        .font(.custom("DIN Alternate", size: 50))
                        .foregroundColor(Color.white)
                        .opacity(0.9)
                        .padding(10)
                    
                    //Sound Description
                    Text(self.userData.allScenes[page].description)
                        .font(.custom("DIN Condensed", size: 14))
                        .foregroundColor(Color.white)
                        .opacity(0.9)
                }
                .frame(width: proxy.size.width, height: proxy.size.height/1.5, alignment: .top)
                .offset(x: 0, y: 20)
                
            }
            .cornerRadius(10)
            .shadow(radius: 5)
        
        }
    }
}


#if DEBUG

var mockData = UserData(
    allScenes: [
        SoundScene(title: "Ocean",
                   description: "Sleep to the sound of ocean waves",
                   soundURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   coverURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   length: 100),
        SoundScene(title: "Ecstacy",
                   description: "Sleep to the sound of mountain wind",
                   soundURL: "https://images.ctfassets.net/ooa29xqb8tix/6NCSjAxuA8EaEgkauQuKso/e3b1c4f38fa5e3899ca0f6d9c98370cd/iPhone_X_Wallpaper_9.png",
                   coverURL: "https://images.ctfassets.net/ooa29xqb8tix/6NCSjAxuA8EaEgkauQuKso/e3b1c4f38fa5e3899ca0f6d9c98370cd/iPhone_X_Wallpaper_9.png",
                   length: 100),
        SoundScene(title: "Mountain",
                   description: "Sleep to the sound of mountain wind",
                   soundURL: "https://i.pinimg.com/564x/d2/14/be/d214bed6bb5066408070ad70925ab72b.jpg",
                   coverURL: "https://i.pinimg.com/564x/d2/14/be/d214bed6bb5066408070ad70925ab72b.jpg",
                   length: 100)
    ],
    allEffects: [
        SoundEffect(title: "Fireplace", iconURL: "flame", fileURL: "https://example.aac", volume: 50),
        SoundEffect(title: "Thunder Storm", iconURL: "bolt.fill", fileURL: "https://example.aac", volume: 50),
        SoundEffect(title: "Wind", iconURL: "wind", fileURL: "https://example.aac", volume: 50),
        SoundEffect(title: "Rain", iconURL: "cloud.drizzle", fileURL: "https://example.aac", volume: 50),
        SoundEffect(title: "Plane", iconURL: "airplane", fileURL: "https://example.aac", volume: 50)
    ]
)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //Standard Screen Preview
            ContentView().environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
            ContentView().environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}

#endif
