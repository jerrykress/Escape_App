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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userData: UserData
    
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
                .isHidden(self.isSessionCompleted)
                
                // MARK: Clock
                VStack {
                    Text("\(String(format: "%02d", self.calendar.component(.hour, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("Satisfaction", size: 80))
                        .opacity(0.7)
                    Text("\(String(format: "%02d", self.calendar.component(.minute, from: self.date)))")
                        .foregroundColor(Color.white)
                        .font(.custom("Satisfaction", size: 80))
                        .opacity(0.5)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .padding(.top, 50)
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
                .isHidden(self.isSessionCompleted)
                
                
                // MARK: Stop Button
                Button(action: {
                    print("Stop Session Button Pressed")
                    self.sessionEndDate = Date()
                    let tempDuration = self.sessionEndDate - self.sessionStartDate
                    self.sessionDuration = (tempDuration.hour!, tempDuration.minute!)
                    withAnimation {
                        self.isSessionCompleted.toggle()
                    }
                }) {
                    Image(systemName: "stop")
                    .foregroundColor(.white)
                    .opacity(0.6)
                }
                .buttonStyle(NoFillBorderButtonStyle())
                .frame(width: 0, height: self.isSessionCompleted ? 0 : 580, alignment: .bottom) //A conditional operator used to hide the button
                
                // MARK: FX Pane Button
                Button(action: {
                    withAnimation {
                        self.isFXPanePresented.toggle()
                    }                    
                }) {
                   Image(systemName: "command")
                   .foregroundColor(.white)
                   .opacity(0.6)
                }
                .buttonStyle(NoFillBorderButtonStyle())
                .frame(width: 0, height: self.isSessionCompleted ? 0 : 390, alignment: .bottom)
                
                
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
                                self.isSessionCompleted.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Image(systemName: "multiply")
                            .foregroundColor(.white)
                            .opacity(0.6)
                        }
                        .buttonStyle(NoFillBorderButtonStyle())
                        .frame(width: 0, height: 580, alignment: .bottom)
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
                    .offset(x: 0, y: proxy.size.height/10)
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
            SessionView().environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            //Standard Screen Preview
            SessionView().environmentObject(mockData)
                .previewDevice(PreviewDevice(rawValue: "iPhone X"))
                .previewDisplayName("iPhone X")
        }
    }
}

#endif
