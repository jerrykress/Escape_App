//
//  ContentView.swift
//  Escape
//
//  Created by Jerry Kress on 02/11/2020.
//

import SwiftUI
import CoreData
import AVKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var userData: UserData
    
    @AppStorage("defaultScene") private var defaultScene: Int = 0
    // Persist Store :Alarm
    @AppStorage("alarmHour") private var alarmHour: Int = 12
    @AppStorage("alarmMin") private var alarmMin: Int = 0
    @AppStorage("alarmToggle") private var alarmToggle: Bool = false
    
    @State var isSessionViewPresented: Bool = false
    @State var isTimerSettingsPresented: Bool = false
    @State var isAlarmSettingsPresented: Bool = false
    
    @State var isSessionReady: Bool = false
    
    @State var player : AVAudioPlayer!
    @State var del = AVdelegate()

    var body: some View {
        
        // MARK: - Home View
        GeometryReader { proxy in
            
            ZStack {
                // Title with overlay when session is ready
                DissolveGradient()
                    .mask(
                        Text(self.userData.getCurrentScene().title)
                            .font(.custom("Avenir Book", size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(Color.white)
                            .opacity(0.8)
                            .padding(10)
                    )
                    .opacity(isSessionReady ? 1 : 0)
                
                HStack{
                    //Sleep Button
                    Button(action: {
                        withAnimation {
                            self.isSessionReady.toggle()
                        }
                    }){
                        Image(systemName: "multiply")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    }
                    .padding(.all, 30)
                    
                    Button(action: {
                        //MARK: Session Start Action
                        withAnimation(.easeIn(duration: 0.5)) {
                            // Start Session
                            self.isSessionViewPresented.toggle()
                            // Setup player to play the correct file
                            // Set up audio player
                            let playerUrl = Bundle.main.path(forResource: self.userData.getCurrentScene().soundURL, ofType:"mp3")
                            self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: playerUrl!))
                            self.player.delegate = self.del
                            self.player.prepareToPlay()
                            self.player.numberOfLoops = -1
                            // Show sessio view and start playing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay
                                self.isSessionReady = false // Restore Image to Full Size
                                self.player.play()
                            }
                        }
                    }){
                        Image(systemName: "play")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    }
                    .padding(.all, 30)
                }
                .opacity(0.7)
                .offset(x: 0, y: 300)
                .isHidden(!isSessionReady)

                
                TabView(selection: self.$userData.currentTrackIndex) {
                    ForEach(Array(0..<self.userData.getAllScene().count), id: \.self) { idx in
                        
                        
                        // MARK: Main View
                        ZStack {
                            
                            ZStack {
                                
                                //Sound Title
                                Text(self.userData.getSceneByIndex(index: idx).title)
                                    .font(.custom("Avenir Book", size: 55))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color.white.opacity(0.8))
                                    .opacity(isSessionReady ? 0 : 1)
                                    .padding(10)
                            }
                            .isHidden(self.isAlarmSettingsPresented)
                            
                        }
                        .cornerRadius(20)
                    }
                    
                }.onAppear(perform: {
                    // disable scroll bounce to hide tabview scroll
                    UIScrollView.appearance().bounces = false
                })
                .tabViewStyle(PageTabViewStyle())
                .animation(.easeOut(duration: 0.5))
                .frame(width: proxy.size.width, height: proxy.size.height/1.8, alignment: .center)
                .opacity(isSessionReady ? 0 : 1)
                
                
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
                            ZStack{
                                Circle()
                                    .fill(Color.clear)
                                Image(systemName: "timer")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                            }
                        }
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.all, 30)
                        .isHidden(self.isSessionReady)
                        
                        //Sleep Button
                        Button(action: {
                            withAnimation {
                                self.isSessionReady.toggle()
                            }
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .opacity(0.25)
                                Image(systemName: "moon.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 60, height: 60, alignment: .center)
                        .padding(.all, 30)
                        .isHidden(self.isSessionReady)
                        
                        // Alarm Button
                        Button(action: {
                            withAnimation {
                                self.isAlarmSettingsPresented = true
                            }
                        }){
                            ZStack{
                                Circle()
                                    .fill(Color.clear)
                                Image(systemName: "alarm")
                                    .resizable()
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                            }
                        }
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.all, 30)
                        .sheet(isPresented: self.$isAlarmSettingsPresented) {
                            AlarmSheet()
                        }
                        .isHidden(self.isSessionReady)
                        
                    }
                    .frame(width: 300, height: 80, alignment: .center)
                    .cornerRadius(40)
                    .padding(.bottom, 70)
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            
            // MARK: Session View
            if(self.isSessionViewPresented) {
                SessionView(isSessionViewPresented: self.$isSessionViewPresented, player: self.$player)
            }
        }
        .background(
            ZStack{
                DissolveGradient()
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                Color.black.opacity(isSessionReady ? 1 : 0)
            }
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            print("HomeView Appeared")
            
            for scene in self.userData.getAllScene() {
                print("Init scene: \(scene.title)")
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
        ContentView()
            .environmentObject(mockData)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

#endif

