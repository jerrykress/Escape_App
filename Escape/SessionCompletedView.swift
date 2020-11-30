//
//  SessionCompletedView.swift
//  Escape
//
//  Created by Jerry Kress on 30/11/2020.
//

import SwiftUI

struct SessionCompletedView: View {
    @Binding var isSessionViewPresented: Bool
    @Binding var sessionDuration: (Int, Int)
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack {
                LinearGradient(gradient: .init(colors: [Color(red: 255/255, green: 175/255, blue: 189/255), Color(red: 255/255, green: 195/255, blue: 160/255)]), startPoint: .top, endPoint: .bottom)
                
                SunriseEmitter()
                .opacity(0.5)
                
                VStack {
                    Text("You had a tight sleep for")
                        .font(.custom("DIN Condensed", size: 20))
                        .foregroundColor(Color.white)
                        .padding()
                        .opacity(0.5)
                    
                    HStack {
                        Text("\(self.sessionDuration.0)")
                            .font(.custom("DIN Alternate", size: 80))
                        Text("hr")
                        Text("\(self.sessionDuration.1 - self.sessionDuration.0 * 60)")
                            .font(.custom("DIN Alternate", size: 80))
                        Text("min")
                    }
                    .foregroundColor(Color.white)
                }
                
                //Back to Home Button
                Button(action: {
                    print("Return Button Pressed")
                    withAnimation {
                        self.isSessionViewPresented.toggle()
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .opacity(0.6)
                }
                .frame(width: 50, height: 50, alignment: .center)
                .offset(x: 0, y: proxy.size.height/2 - 100)
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            
        }
    }
}

// preview with constant
struct SessionCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SessionCompletedView(isSessionViewPresented: .constant(true), sessionDuration: .constant((0,0)))
    }
}
