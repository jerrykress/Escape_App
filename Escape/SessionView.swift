//
//  SessionView.swift
//  Velvet
//
//  Created by Jerry Kress on 09/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import AVKit

struct SessionView: View {
    @EnvironmentObject var userData: UserData
    
    @Binding var isSessionViewPresented: Bool
    @Binding var player: AVAudioPlayer!
    
    @State private var isSessionCompleted = false
    @State private var isFXPanePresented = false
    
    @State private var showBanner = false
    @State private var bannerContent: (String, String) = ("Timer","Off")
    
    @State private var showAlarmSheet: Bool = false
    @State private var alarmTime: Date = Date()
    
    @State private var calendar = Calendar.current
    @State private var date = Date()
    
    @State private var sessionStartDate = Date()
    @State private var sessionEndDate = Date()
    @State private var sessionDuration: (Int, Int) = (0,0)
    
    @State private var timerUpdateInterval: Int = 0
    
    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter
    }
    
    // MARK: Scheduled Timer
    var updateTimer: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
                                // update clock
                                self.date = Date()
                                // update countdown timer if timer is enabled
                                if(self.userData.timerEnabled){
                                    // resume playing when timer is re-enabled
                                    if(!self.player.isPlaying){
                                        self.player.play()
                                    }
                                    // tic toc
                                    self.timerUpdateInterval = (self.timerUpdateInterval + 1) % 60
                                    // decrement timer once every minute
                                    if(timerUpdateInterval == 0){
                                        if(self.userData.timer > 0){
                                            self.userData.timer = self.userData.timer - 1
                                        }
                                        // disable timer when it counts down to 0 and stop music
                                        if(self.userData.timer == 0){
                                            self.userData.timerEnabled = false
                                            self.player.stop()
                                        }
                                    }
                                    
                                }

                              })
    }
    
    // MARK: Session View
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                //Backgroud
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(EmitterView().opacity(0.5))
                
                NotificationBanner(showBanner: self.$showBanner, content: self.$bannerContent)
                    .padding(.top, 40)
                    .frame(width: proxy.size.width/1.2, height: proxy.size.height, alignment: .top)
                
                
                
                // MARK: Navigation Bar
                HStack (alignment: .center) {
                    
                    // MARK: LHS Button
                    TimerHandler(showBanner: self.$showBanner, bannerContent: self.$bannerContent)
                        .padding(.top, 5)
                        .opacity(0.6)
                        .disabled(self.showBanner)
                    
                    Spacer()
                    
                    // MARK: Now Playing
                    VStack {
                        Text("Now playing")
                            .foregroundColor(Color.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .opacity(0.7)
                            .padding(.bottom, 10)
                        
                        Text("\(self.userData.getCurrentScene().title)")
                            .foregroundColor(Color.white)
                            .font(.system(size: 15, weight: .light, design: .default))
                            .opacity(0.7)
                    }
                    .isHidden(self.showBanner)

                    
                    Spacer()
                    
                    // MARK: RHS Button
                    FXButtonHandler(isFXPanePresented: self.$isFXPanePresented)
                        .padding(.top, 5)
                        .opacity(0.6)
                    
                }
                .padding(.top, 60) // TODO: Find universial number
                .frame(width: proxy.size.width/1.2, height: proxy.size.height, alignment: .top)
                
                
                VStack {
                    // MARK: Clock
                    Text("\(String(format: "%02d", self.calendar.component(.hour, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 80))
                        .padding(.top, 30)
                        .opacity(0.7)
                    Text("\(String(format: "%02d", self.calendar.component(.minute, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 80))
                        .opacity(0.5)
                    
                    
                    // MARK: Alarm Button
                    Button(action: {
                        withAnimation {
                            self.showAlarmSheet = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "alarm")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12, alignment: .center)
                            
                            Text("Alarm")
                            .foregroundColor(Color.offWhite)
                            .font(.system(size: 15, weight: .regular, design: .default))
                        }
                    }
                    .offset(x: 0, y: -30)
                    .opacity(0.6)
                    .sheet(isPresented: self.$showAlarmSheet) {
                        AlarmSheet()
                    }
                    

                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .padding(.top, 5)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
                
                  
                // MARK: Slide to End
                Group {
                    SlidetoUnlockView(thumbnailTopBottomPadding: 5,
                                      thumbnailLeadingTrailingPadding: 5,
                                      text: "Slide to End",
                                      textFont: .custom("DIN Alternate", size: 20),
                                      textFontWeight: .regular,
                                      textColor: .offWhite,
                                      thumbnailColor: Color.gray,
                                      sliderBackgroundColor: Color.black,
                                      didReachEndAction: { view in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.sessionEndDate = Date()
                                            let tempDuration = self.sessionEndDate - self.sessionStartDate
                                            self.sessionDuration = (tempDuration.hour!, tempDuration.minute!)
                                            withAnimation {
                                                // When session ends
                                                self.isSessionCompleted.toggle()
                                                // Stop music playing
                                                self.player.stop()
                                                // Deactivate audio session
                                                try! AVAudioSession.sharedInstance().setActive(false)
                                            }
                                        }
                                    })
                                    .frame(width: proxy.size.width/1.2, height: 50)
                                    .background(Color.gray)
                                    .cornerRadius(25)
                }
                .frame(width: proxy.size.width, height: proxy.size.height/1.2, alignment: .bottom)
                .opacity(0.7)
                
                
                if(self.isFXPanePresented) {
                    FXPane(isFXPanePresented: self.$isFXPanePresented)
                        .background(Color.clear)
                }
                
                
                //MARK: Session Completed View
                if(self.isSessionCompleted) {
                    ZStack {
                        SunriseEmitter()
                        .opacity(0.5)
                        
//                        Text("Good Morning")
//                            .font(.custom("DIN Condensed", size: 35))
//                            .foregroundColor(Color.white)
//                            .offset(x: 0, y: -90)
//                            .opacity(0.5)
                        
                        VStack {
                            Text("You had a tight sleep for")
                                .font(.custom("DIN Condensed", size: 20))
                                .foregroundColor(Color.white)
                                .padding()
                                .opacity(0.5)
                            
                            HStack {
                                Text("\(self.sessionDuration.0)")
                                    .font(.custom("DIN Alternate", size: 80))
                                Text("hr")
                                Text("\(self.sessionDuration.1 - self.sessionDuration.0 * 60)")
                                    .font(.custom("DIN Alternate", size: 80))
                                Text("min")
                            }
                            .foregroundColor(Color.white)
                        }
                        
                        //Back to Home Button
                        Button(action: {
                            print("Return Button Pressed")
                            withAnimation {
                                self.isSessionViewPresented.toggle()
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .opacity(0.6)
                        }
                        .frame(width: 50, height: 50, alignment: .center)
                        .offset(x: 0, y: proxy.size.height/2 - 100)
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .background(LinearGradient(gradient: .init(colors: [Color(red: 255/255, green: 175/255, blue: 189/255), Color(red: 255/255, green: 195/255, blue: 160/255)]), startPoint: .top, endPoint: .bottom))
                    
                }
                
            }
            .onAppear(perform: {
                do {
                    // Enable background audio
                    try AVAudioSession.sharedInstance().setCategory(
                        AVAudioSession.Category.playback,
                            mode: AVAudioSession.Mode.default,
                            options: [
                                AVAudioSession.CategoryOptions.duckOthers
                            ]
                    )
                    // Active audio session
                    try! AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Could not active background audio session")
                }
                // keep timer ticking so that clock is correct
                let _ = self.updateTimer
                self.sessionStartDate = Date()
                print("STATUS: SessionView Appeared")
                
            })
            .onDisappear(perform: {
                let _ = self.updateTimer
            })
            
        }
    }
    
}




class AVdelegate : NSObject,AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name("Finish"), object: nil)
    }
}





#if DEBUG

//struct SessionView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            //Larger Screen Preview
//            SessionView(isSessionViewPresented: .constant(true)).environmentObject(mockData)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
//                .previewDisplayName("iPhone 11 Pro Max")
//        }
//    }
//}

#endif
