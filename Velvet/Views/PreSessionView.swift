//
//  AlarmSettingsView.swift
//  Velvet
//
//  Created by Jerry Kress on 02/07/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct AlarmSettingsView: View {
    @Binding var presented: Bool
    
    @State private var selectedHour = 8
    @State private var selectedMinute = 30
    
    var body: some View {
            GeometryReader { geometry in
//                ZStack {
                    
                VStack {
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
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        self.presented = false
                    }) {
                        Text("Done")
                            .foregroundColor(Color.white)
                            .opacity(0.7)
                            .font(.title2)
                            .frame(width: 100, height: 46, alignment: .center)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(23)
                    }
                    
                }
                    
//                }
                
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
                    
                    AlarmSettingsView(presented: .constant(true))
                        .frame(width: 200, height: 300, alignment: .center)
                        .compositingGroup() // ! Fixes Picker Touch Area Bug
                        .clipped()
                    
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
