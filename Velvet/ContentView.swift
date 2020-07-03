//
//  ContentView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage


struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @State var isSessionViewPresented: Bool = false
    
    var body: some View {
            
        // MARK: - Home View
        GeometryReader { proxy in
            
            ZStack {
                
                TabView(selection: self.$userData.currentTrackIndex) {
                    ForEach(self.userData.idx, id: \.self) { idx in
                        ZStack {
                            //Background
                            
                            Group{
                                URLImage(URL(string: self.userData.allScenes[idx].coverURL)!,
                                         expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                                         content: {
                                              $0.image
                                                .resizable()
                                                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                                         })
                            }
                            .frame(height: (self.userData.currentTrackIndex == idx) ? proxy.size.height : proxy.size.height/1.1)
                            
                            VStack {
                                //Sound Title
                                Text(self.userData.allScenes[idx].title)
                                    .font(.custom("DIN Alternate", size: 50))
                                    .foregroundColor(Color.white)
                                    .opacity(0.9)
                                    .padding(10)
                                
                                //Sound Description
                                Text(self.userData.allScenes[idx].description)
                                    .font(.custom("DIN Condensed", size: 14))
                                    .foregroundColor(Color.white)
                                    .opacity(0.9)
                            }
                            .frame(width: proxy.size.width, height: proxy.size.height/1.2, alignment: .top)
                        }
                        .cornerRadius(15)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeOut)
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                
                
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
                .frame(width: 0, height: proxy.size.height/1.3, alignment: .bottom)
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .background(Color.black)
            
            // MARK: Session View
            if(self.isSessionViewPresented) {
                SessionView(isSessionViewPresented: self.$isSessionViewPresented)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
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
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
        }
    }
}

#endif
