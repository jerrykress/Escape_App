//
//  FXButtonHandler.swift
//  Velvet
//
//  Created by Jerry Kress on 30/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct FXButtonHandler: View {
    @EnvironmentObject var userData: UserData
    @Binding var isFXPanePresented: Bool
    @State var textStatus: String = "Off"
    
    var updateStatus: Timer {
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true,
                              block: {_ in
                                 isFXActivated()
                               })
    }
    
    var body: some View {
        Button(action: {
            isFXActivated()
            withAnimation {
                self.isFXPanePresented.toggle()
            }
        }) {
            VStack {
                Image(systemName: "dial.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    .frame(width: 22, height: 22, alignment: .center)
                
                Text(self.textStatus)
                    .foregroundColor(Color.white)
                    .font(.custom("DIN Alternate", size: 13))
                    .opacity(0.5)
            }
            .frame(width: 40, height: 40, alignment: .center)
            .contentShape(Rectangle())
        }
        .onAppear(perform: {
            isFXActivated()
            let _ = self.updateStatus
        })
    }
    
    func isFXActivated() -> Void {
        for effect in self.userData.allEffects {
            if(effect.volume != 0) {
                self.textStatus = "On"
                return
            }
        }
        self.textStatus = "Off"
        return
    }
}


struct TestFXButtonHandler: View {
    @EnvironmentObject var userData: UserData
    @State var showFXPane: Bool = false
    
    var body: some View {
        ZStack {
            FXButtonHandler(isFXPanePresented: self.$showFXPane)
        }
        .background(Color.black)
    }
}


struct FXButtonHandler_Previews: PreviewProvider {
    static var previews: some View {
        TestFXButtonHandler().environmentObject(mockData)
    }
}
