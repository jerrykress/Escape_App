//
//  AlarmSoundingView.swift
//  Escape
//
//  Created by Jerry Kress on 30/11/2020.
//

import SwiftUI
import AVKit

struct AlarmSoundingView: View {
    @Binding var alarmSounding: Bool
    @Binding var isSessionCompleted: Bool
    @Binding var snoozed: Bool
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                LinearGradient(gradient: .init(colors: [Color(red: 239/255, green: 213/255, blue: 255/255), Color(red: 81/255, green: 90/255, blue: 180/255)]), startPoint: .top, endPoint: .bottom)
                
                    Text("Time to Wake Up")
                        .font(.custom("DIN Condensed", size: 40))
                        .foregroundColor(Color.white)
                        .padding()
                        .opacity(0.7)
                    
                HStack{
                    Button(action:{
                        withAnimation {
                            self.alarmSounding.toggle()
                            self.isSessionCompleted.toggle()
                        }
                    }){
                        Text("Get Up")
                            .foregroundColor(Color.white)
                            .font(.system(size: 23))
                            .padding(10)
                            .background(Color.white.opacity(0.4))
                            .cornerRadius(25)
                    }
                    .frame(width: 100, height: 50, alignment: .center)
                    
                    Spacer()
                    
                    Button(action:{
                        withAnimation {
                            self.alarmSounding.toggle()
                            self.snoozed = true
                        }
                    }){
                        Text("Snooze")
                            .foregroundColor(Color.white)
                            .font(.system(size: 23))
                            .padding(10)
                            .background(Color.white.opacity(0.4))
                            .cornerRadius(25)
                    }
                    .frame(width: 100, height: 50, alignment: .center)
                }
                .opacity(0.7)
                .frame(width: 250, height: proxy.size.height-80, alignment: .bottom)
                    
                    
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}


struct AlarmSoundingView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSoundingView(alarmSounding: .constant(true),
                          isSessionCompleted: .constant(false),
                          snoozed: .constant(false))
    }
}
