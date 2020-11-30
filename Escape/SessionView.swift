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
    
    @State private var calendar = Calendar.current
    @State private var date = Date() // clock data
    
    @State private var sessionStartDate = Date()
    @State private var sessionEndDate = Date()
    @State private var sessionDuration: (Int, Int) = (0,0)
    
    @AppStorage("timerLength") private var timerLength: Int = 1800 // default 1800 seconds (30 min)
    // Persistent storage for alarm
    @AppStorage("alarmToggle") private var alarmToggle: Bool = false
    @AppStorage("alarmHour") private var alarmHour: Int = 12;
    @AppStorage("alarmMin") private var alarmMin: Int = 0;
    
    @State private var snoozed: Bool = false
    @State private var hasAlarmSounded: Bool = false
    @State private var alarmSounding: Bool = false
    
    // MARK: Published Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                                                // cancel timer when session is ended
                                                self.timer.upstream.connect().cancel()
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
                
                //MARK: Alarm Sounding
                if(self.alarmSounding){
                    AlarmSoundingView(alarmSounding: self.$alarmSounding, isSessionCompleted: self.$isSessionCompleted)
                }
                
                
                //MARK: Session Completed
                if(self.isSessionCompleted) {
                    SessionCompletedView(isSessionViewPresented: self.$isSessionViewPresented, sessionDuration: self.$sessionDuration)
                }
                
            }
            .onAppear(perform: {
            //MARK: On Appear
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
                // start playing immediately if timer is on
                if(self.userData.timer != 0){
                    self.player.play()
                }
                // keep timer ticking so that clock is correct
                self.sessionStartDate = Date()
                print("STATUS: SessionView Appeared")
                
            })
            .onDisappear(perform: {
                // stop player again just in case
                self.player.stop()
                // reset timer
                self.timerLength = self.userData.timer * 60
            })
            //MARK: Timer Action
            .onReceive(self.timer){ time in
                print(self.timerLength, "\n")
                // update clock
                self.date = Date()
                // check if its time to sound the alarm
                let components = Calendar.current.dateComponents([.hour, .minute], from: self.date)
                if(components.hour == self.alarmHour && components.minute == self.alarmMin){
                    //if alarm is enabled
                    if(self.alarmToggle && !self.hasAlarmSounded){
                        withAnimation {
                            self.alarmSounding.toggle()
                            self.hasAlarmSounded = true
                        }
                    }
                }
                // decrement timer every second
                if(self.timerLength > 0){
                    self.timerLength -= 1
                }
                // stop music when timer is 0
                if(self.timerLength == 0 && self.player.isPlaying){
                    self.player.stop()
                }
                // if timer has been re-enabled, resume
                if(self.timerLength != 0 && !self.player.isPlaying){
                    self.player.play()
                }
                
            }
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
