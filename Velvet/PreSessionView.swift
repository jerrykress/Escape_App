//
//  AlarmSettingsView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/07/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct AlarmSettingsView: View {
    @State private var selectedHour = 8
    @State private var selectedMinute = 30
    
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    
                    HStack(spacing: 0) {
                        
                        // MARK: HOUR
                        Picker(selection: self.$selectedHour, label: EmptyView()) {
                            ForEach(0 ..< 24) {
                                Text("\($0)")
                            }
                        }
                        .colorInvert()
                        .pickerStyle(WheelPickerStyle())
                        .onReceive([self.selectedHour].publisher.first()) { (value) in
                            print("hour: \(value)")
                        }
                        .labelsHidden()
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        
                        // MARK: MINUTE
                        Picker(selection: self.$selectedMinute, label: EmptyView()) {
                            ForEach(0 ..< 60) {
                                Text("\($0)")
                            }
                        }
                        .colorInvert()
                        .pickerStyle(WheelPickerStyle())
                        .onReceive([self.selectedMinute].publisher.first()) { (value) in
                            print("minute: \(value)")
                        }
                        .labelsHidden()
                        .frame(width: geometry.size.width/2)
                        .clipped()
                        
                    }
                    
                }
                
            }
    }
}

struct TestPreSessionView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("forest")
                    .frame(width: proxy.size.width, height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .colorMultiply(Color.gray)
                    .blur(radius: 10)
                
                VStack {
                    Text("Set Alarm")
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 30))
                        .padding(.bottom, 20)
                        .opacity(0.7)
                    
                    AlarmSettingsView()
                        .frame(width: 200, height: 200, alignment: .center)
                        .compositingGroup() // ! Fixes Picker Touch Area Bug
                        .clipped()
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .opacity(0.6)
                    }
                    .frame(width: 50, height: 50, alignment: .center)
                    .padding(.top, 50)
                    .opacity(0.7)
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom, alignment: .center)
            }
            .edgesIgnoringSafeArea(.all)
        }
        


    }
}

struct PreSessionView_Previews: PreviewProvider {
    static var previews: some View {
        TestPreSessionView().previewDevice("iPhone X")
    }
}
