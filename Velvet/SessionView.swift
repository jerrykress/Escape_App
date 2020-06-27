//
//  SessionView.swift
//  Velvet
//
//  Created by Jerry Kress on 09/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage



struct SessionView: View {
    @EnvironmentObject var userData: UserData
    
    @Binding var isSessionViewPresented: Bool
    
    @State private var isSessionCompleted = false
    @State private var isFXPanePresented = false
    
    @State private var calendar = Calendar.current
    @State private var date = Date()
    
    @State private var sessionStartDate = Date()
    @State private var sessionEndDate = Date()
    @State private var sessionDuration: (Int, Int) = (0,0)
    
    
    var timeFormat: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter
    }
    
    var updateTimer: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
                                 self.date = Date()
                               })
    }
    
    // MARK: Session View
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                //Backgroud
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .overlay(EmitterView()
                                .opacity(0.5))
                

                // MARK: Now Playing
                VStack {
                    Text("Now playing")
                        .foregroundColor(Color.white)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .opacity(0.7)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Text("\(self.userData.allScenes[self.userData.currentTrackIndex].title)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .opacity(0.7)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
                .offset(x: 0, y: proxy.safeAreaInsets.top)
                .isHidden(self.isSessionCompleted)
                
                // MARK: Clock
                VStack {
                    Text("\(String(format: "%02d", self.calendar.component(.hour, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 80))
                        .opacity(0.7)
                    Text("\(String(format: "%02d", self.calendar.component(.minute, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 80))
                        .opacity(0.5)
                    
                    // MARK: FX Pane Button
                    Button(action: {
                        withAnimation {
                            self.isFXPanePresented.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "command")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12, alignment: .center)
                            
                            Text("Effects")
                                .foregroundColor(Color.offWhite)
                                .font(.system(size: 14, weight: .regular, design: .default))
                        }
                    }
                    .opacity(0.6)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .padding(.top, 25)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
                .isHidden(self.isSessionCompleted)
                
                  
                // MARK: Stop Button
//                Button(action: {
//                    print("Stop Session Button Pressed")
//                    self.sessionEndDate = Date()
//                    let tempDuration = self.sessionEndDate - self.sessionStartDate
//                    self.sessionDuration = (tempDuration.hour!, tempDuration.minute!)
//                    withAnimation {
//                        self.isSessionCompleted.toggle()
//                    }
//                }) {
//                    Image(systemName: "stop")
//                    .foregroundColor(.white)
//                    .opacity(0.6)
//                }
//                .buttonStyle(NoFillBorderButtonStyle())
//                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
//                .offset(x: 0, y: -proxy.size.height/10)
                
                Group {
                    SlidetoUnlockView(thumbnailTopBottomPadding: 5,
                                      thumbnailLeadingTrailingPadding: 5,
                                      text: "Slide to End",
                                      textColor: .offWhite,
                                      thumbnailColor: Color.gray,
                                      sliderBackgroundColor: Color.black,
                                      didReachEndAction: { view in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.sessionEndDate = Date()
                                            let tempDuration = self.sessionEndDate - self.sessionStartDate
                                            self.sessionDuration = (tempDuration.hour!, tempDuration.minute!)
                                            withAnimation {
                                                self.isSessionCompleted.toggle()
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
                
                
                //MARK: Session Complete View
                if(self.isSessionCompleted) {
                    
                    //Session Information Card
                    ZStack {
                        VStack {
                            Text("You have slept for \n \(self.sessionDuration.0) hours \(self.sessionDuration.1) minutes")
                            .padding(20)
                        }
                        .frame(width: proxy.size.width/1.3, height: proxy.size.height/2, alignment: .center)
                        .background(Color.offWhite)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        
                        //Back to Home Button
                        Button(action: {
                            print("Return Button Pressed")
                            withAnimation {
//                                self.isSessionCompleted.toggle()
                                self.isSessionViewPresented.toggle()
                            }
                        }) {
                            Image(systemName: "multiply")
                            .foregroundColor(.white)
                            .opacity(0.6)
                        }
                        .buttonStyle(BlurryRoundButtonStyle())
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                    .background(Image("sunrise"))
                    
                }
                
            }
            .onAppear(perform: {
                let _ = self.updateTimer
                self.sessionStartDate = Date()
            })
            .onDisappear(perform: {
                let _ = self.updateTimer
            })
            
        }
        .navigationBarBackButtonHidden(true) //Disable Back Swipe Gesture
    }
    
}


#if DEBUG

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //Larger Screen Preview
            SessionView(isSessionViewPresented: .constant(true)).environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            //Standard Screen Preview
            SessionView(isSessionViewPresented: .constant(true)).environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }
    }
}

#endif
