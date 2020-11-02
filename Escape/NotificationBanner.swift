//
//  NotificationBanner.swift
//  Velvet
//
//  Created by Jerry Kress on 29/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct NotificationBanner: View {
    @Binding var showBanner: Bool
    @Binding var content: (String, String)
    
    @State var foregroundColor: Color = Color.black
    @State var backgroundColor: Color = Color.white
    
    var body: some View {
        ZStack {
            
            if self.showBanner {
                VStack {
                    HStack(alignment: .center) {
                        
                        // Text Content
                        VStack(alignment: .center, spacing: 2) {
                            Text(self.content.0)
                            .bold()
                            
                            Text(self.content.1)
                            .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))

                        }
                        
                    }
                    .frame(width: 180, height: 52, alignment: .center)
                    .foregroundColor(self.foregroundColor)
                    .background(self.backgroundColor)
                    .cornerRadius(26)
                    .opacity(0.7)
                                        
                    Spacer()
                }
                .padding()
                .animation(.easeInOut)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    withAnimation {
                        self.showBanner = false
                    }
                }.onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.showBanner = false
                        }
                    }
                })
            }
        }
    }
}

struct TestBanner: View {
    @State var showTestBanner = false
    @State var testNotification: (String, String) = ("","")
    
    var body: some View {
        
        ZStack {
            Color.black
            NotificationBanner(showBanner: self.$showTestBanner, content: self.$testNotification)
            
            Button(action: {
                self.testNotification = ("Timer On","100 mins")
                self.showTestBanner.toggle()
            }) {
                Text("Test Banner")
                    .foregroundColor(Color.white)
            }
            
        }
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        TestBanner()
    }
}
