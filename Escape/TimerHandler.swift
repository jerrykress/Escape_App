//
//  TimerHandler.swift
//  Velvet
//
//  Created by Jerry Kress on 30/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct TimerHandler: View {
    @EnvironmentObject var userData: UserData
    @Binding var showBanner: Bool
    @Binding var bannerContent: (String, String)
    @State var timerSetting: Int = 0
    
    var body: some View {
        Button(action: {
            self.timerSetting = (self.timerSetting + 30) % 120
            self.userData.timer = self.timerSetting
            
            withAnimation {
                self.bannerContent = ("Timer","\(self.timerSetting) mins")
                
                if(self.timerSetting == 0) {
                    self.bannerContent.1 = "Off"
                }
                
                if(!self.showBanner){
                    self.showBanner.toggle()
                }
            }
        }) {
            VStack {
                Image(systemName: "timer")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20, alignment: .center)
                
                Text(self.userData.timer == 0 ? "Off" : "\(self.userData.timer)")
                                .foregroundColor(Color.white)
                                .font(.custom("DIN Alternate", size: 13))
                                .opacity(0.5)
            }
            .frame(width: 40, height: 40, alignment: .center)
            .contentShape(Rectangle())
        }
    }
}


struct TestTimerHandler: View {
    @EnvironmentObject var userData: UserData
    @State var showBanner: Bool = false
    @State var bannerContent: (String, String) = ("Timer","Off")
    
    var body: some View {
        ZStack {
            TimerHandler(showBanner: self.$showBanner, bannerContent: self.$bannerContent)
        }
        .background(Color.black)
        
    }
}


struct TimerHandler_Previews: PreviewProvider {
    static var previews: some View {
        TestTimerHandler().environmentObject(mockData)
    }
}
