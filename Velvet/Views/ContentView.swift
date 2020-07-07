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
    @State var isTimerSettingsPresented: Bool = false
    @State var isAlarmSettingsPresented: Bool = false
    
    @State var isSessionReady: Bool = false
    
    var body: some View {
            
        // MARK: - Home View
        GeometryReader { proxy in
            
            ZStack {
                // Blurred Background View
                DissolveGradient()
                    .opacity(self.isSessionReady ? 1 : 0)
                
                TabView(selection: self.$userData.currentTrackIndex) {
                    ForEach(self.userData.idx, id: \.self) { idx in
                        
                        // MARK: Main View
                        ZStack {
                            
                            //Background
                            URLImage(URL(string: self.userData.allScenes[idx].coverURL)!,
                                     expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                                     content: {
                                          $0.image
                                            .resizable()
                                     }
                            )
                            .frame(width: (self.isSessionReady) ? proxy.size.width/1.6 : proxy.size.width,
                                   height: (self.isSessionReady) ? proxy.size.height/2 : proxy.size.height*1.2)
                            .opacity((self.userData.currentTrackIndex == idx) ? 1 : 0)
                            
                            
                            
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
                                
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: self.isSessionReady ? 20 : 0,
                                           height: self.isSessionReady ? 20 : 0, alignment: .center)
                                    .opacity(0.7)
                                    .padding(.top, 40)
                                    .onTapGesture {
                                        withAnimation(.easeIn(duration: 0.5)) {
                                            self.isSessionViewPresented.toggle() // Start Session
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay
                                                self.isSessionReady = false // Restore Image to Full Size
                                            }
                                        }
                                    }
                            }
                            .isHidden(self.isAlarmSettingsPresented)
                            
                        }
                        .cornerRadius(25)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeOut(duration: 0.5))
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                
                
                // MARK: Alarm Settings
                AlarmSettingsView(presented: self.$isAlarmSettingsPresented)
                    .frame(width: proxy.size.width/2, height: 200, alignment: .bottom)
                    .colorMultiply(Color.white)
                    .isHidden(!self.isAlarmSettingsPresented)
                
                
                // Function Bar Bottom
                VStack {
                    Spacer()
                    
                    // MARK: Buttons
                    HStack (alignment: .center) {
                        
                        //Timer Button
                        Button(action: {
                            withAnimation {
//                                self.isSessionReady.toggle()
                            }
                        }){
                            Image(systemName: "timer")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        }
                        .padding(.all, 30)
                        .isHidden(self.isSessionReady)
                        
                        //Sleep Button
                        Button(action: {
                            withAnimation {
                                self.isSessionReady.toggle()
                            }
                        }){
                            Image(systemName: self.isSessionReady ? "multiply" : "moon.fill")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.white)
                            .opacity(self.isSessionReady ? 0.5 : 0.8)
                        }
                        .padding(.all, 30)

                        
                        // Alarm Button
                        Button(action: {
                            withAnimation {
                                self.isAlarmSettingsPresented = true
                            }
                        }){
                            Image(systemName: "alarm")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        }
                        .padding(.all, 30)
                        .isHidden(self.isSessionReady)
                        
                    }
                    .frame(width: self.isSessionReady ? 55 : 300,
                           height: self.isSessionReady ? 55 : 80, alignment: .center)
                    .background(Color.black.opacity(self.isSessionReady ? 0.2 : 0.4))
                    .cornerRadius(40)
                    .padding(.bottom, 70)
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .background(Color.darkEnd)
            
            // MARK: Session View
            if(self.isSessionViewPresented) {
                SessionView(isSessionViewPresented: self.$isSessionViewPresented)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}


// MARK: - MOCK DATA

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
                   soundURL: "https://media.idownloadblog.com/wp-content/uploads/2019/06/V4ByArthur1992aS-iphone-mountain-wallpaper-sunset-orange.png",
                   coverURL: "https://media.idownloadblog.com/wp-content/uploads/2019/06/V4ByArthur1992aS-iphone-mountain-wallpaper-sunset-orange.png",
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
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
        }
    }
}

#endif
