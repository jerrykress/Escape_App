//
//  AlarmSoundingView.swift
//  Escape
//
//  Created by Jerry Kress on 30/11/2020.
//

import SwiftUI

struct AlarmSoundingView: View {
    @Binding var alarmSounding: Bool
    
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
                        self.alarmSounding.toggle()
                    }){
                        Text("Get Up")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                    }
                    .frame(width: 100, height: 50, alignment: .center)
                    
                    Spacer()
                    
                    Button(action:{
                        self.alarmSounding.toggle()
                    }){
                        Text("Snooze")
                            .foregroundColor(Color.white)
                            .font(.system(size: 25))
                    }
                    .frame(width: 100, height: 50, alignment: .center)
                }
                .opacity(0.7)
                .frame(width: proxy.size.width/2, height: proxy.size.height-80, alignment: .bottom)
                    
                    
                
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TestAlarmView: View {
    @State private var testAlarmSounding = true
    
    var body: some View{
        ZStack{
            Color.white
            AlarmSoundingView(alarmSounding: self.$testAlarmSounding)
        }
    }
}

struct AlarmSoundingView_Previews: PreviewProvider {
    static var previews: some View {
        TestAlarmView()
    }
}
