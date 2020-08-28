//
//  ContentView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var userData: UserData
    
    @State var isSessionViewPresented: Bool = false
    @State var isTimerSettingsPresented: Bool = false
    @State var isAlarmSettingsPresented: Bool = false
    
    @State var isSessionReady: Bool = false
    
    @FetchRequest(
        entity: SoundSceneData.entity(),
        sortDescriptors: []
    ) var soundSceneData: FetchedResults<SoundSceneData>
    
    var body: some View {
            
        // MARK: - Home View
        GeometryReader { proxy in
            
            ZStack {
                // Blurred Background View
                DissolveGradient()
                    .opacity(self.isSessionReady ? 1 : 0)
                
                TabView(selection: self.$userData.currentTrackIndex) {
                    ForEach(Array(0..<self.userData.getAllScene().count), id: \.self) { idx in
                        
                        
                        // MARK: Main View
                        ZStack {
                            
                            //Background
                            URLImage(URL(string: self.soundSceneData[idx].coverURL ?? "undefined")!,
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
                                Text(self.soundSceneData[idx].title ?? "err")
                                    .font(.custom("Avenir Book", size: 45))
                                    .foregroundColor(Color.white)
                                    .opacity(0.8)
                                    .padding(10)
                                
                                //Sound Description
//                                Text(self.userData.allScenes[idx].description)
//                                    .font(.system(size: 15, weight: .regular, design: .default))
//                                    .foregroundColor(Color.white)
//                                    .opacity(0.6)
                                
                                Image(systemName: "livephoto.play")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: self.isSessionReady ? 36 : 0,
                                           height: self.isSessionReady ? 36 : 0, alignment: .center)
                                    .opacity(0.7)
                                    .padding(.top, 30)
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
                        .cornerRadius(20)
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
        .onAppear(perform: {
            print("HomeView Appeared")
            
            for scene in self.userData.getAllScene() {
                print("Init scene: \(scene.title)")
                
                // Create data in context
                guard let sceneData = NSEntityDescription.insertNewObject(forEntityName: "SoundSceneData", into: context) as? SoundSceneData else {
                  return
                }
                
                // Copy Attributes
                sceneData.title = scene.title
                sceneData.subtitle = scene.description
                sceneData.coverURL = scene.coverURL
                sceneData.soundURL = scene.soundURL
                sceneData.length = Int16(scene.length)
                
                // Attempt Saving to Core Data
                do {
                    try context.save()
                } catch {
                    print("Could not save. \(error), \(error.localizedDescription)")
                }
                // Exit Core Data
            }
        })
        
    }
}


// MARK: - MOCK DATA

#if DEBUG

var mockData = UserData(
    allScenes: [
        SoundScene(title: "Ocean",
                   description: "The sound of ocean waves",
                   soundURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   coverURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   length: 100),
        SoundScene(title: "Dunes",
                   description: "The sound of ocean waves",
                   soundURL: "https://wallpaperplay.com/walls/full/8/0/6/114384.jpg",
                   coverURL: "https://wallpaperplay.com/walls/full/8/0/6/114384.jpg",
                   length: 100),
        SoundScene(title: "Cosmos",
                   description: "The sound of ocean waves",
                   soundURL: "https://wallpapercave.com/wp/wp4570367.jpg",
                   coverURL: "https://wallpapercave.com/wp/wp4570367.jpg",
                   length: 100)
    ],
    allEffects: [
        SoundEffect(title: "Fireplace", iconURL: "flame", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Thunder Storm", iconURL: "bolt.fill", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Mountain Wind", iconURL: "wind", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Spring Rain", iconURL: "cloud.drizzle", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Winter Snow", iconURL: "snow", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Rail Road", iconURL: "tram.fill", fileURL: "https://example.aac", volume: 0)
    ]
)

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(mockData)
    }
}

#endif
