//
//  FXPane.swift
//  Velvet
//
//  Created by Jerry Kress on 24/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI


struct FXRowView: View {
    
    @Binding var effect: SoundEffect
    @State var value: Double = 30
    let background = Color(red: 0.07, green: 0.07, blue: 0.12)

    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 80)
                .cornerRadius(15)
                
            VStack {
                Text("\(effect.title)")
                    .foregroundColor(Color.white)
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 10, alignment: .topLeading)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                
                CustomSlider(value: $effect.volume, range: (0, 100), knobWidth: 0) { modifiers in
                  ZStack {
                    
                    LinearGradient(gradient: .init(colors: [self.background, Color.black.opacity(0.6) ]), startPoint: .bottom, endPoint: .top)

                    Group {
                      LinearGradient(gradient: .init(colors: [Color.blue, Color.purple, Color.pink ]), startPoint: .leading, endPoint: .trailing)
                        LinearGradient(gradient: .init(colors: [Color.clear, self.background]), startPoint: .top, endPoint: .bottom).opacity(0.15)
                    }.modifier(modifiers.barLeft)
                    
                    //Text("Volume").foregroundColor(.white).opacity(0.3)
                  }
                  .cornerRadius(15)
                }
                .frame(height: 20)
                .padding(.top, 5)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.bottom, 10)
               
            }
        }
        .padding(10)
        .listRowBackground(Color.black)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct FXPane: View {
    @EnvironmentObject var userData: UserData
    @Binding var isFXPanePresented: Bool
    
    var body: some View {
        
        ZStack {
            
            List(self.userData.allEffects.indices) { idx in
                FXRowView(effect: self.$userData.allEffects[idx])
                
            }
            .onAppear(perform: {
                // Set List background to black
                UITableView.appearance().separatorColor = .black
                UITableView.appearance().backgroundColor = .black
                UITableViewCell.appearance().backgroundColor = .black
            })
            
            // Close FX Pane
            Button(action: {
                withAnimation {
                    self.isFXPanePresented.toggle()
                }
            }) {
                Image(systemName: "multiply")
                .foregroundColor(.offWhite)
                .opacity(0.6)
            }
            .buttonStyle(NoFillBorderButtonStyle())
            .frame(width: 0, height: 580, alignment: .bottom)
        }
        .padding(.top, 20)
        .edgesIgnoringSafeArea(.all)
        
        
    }
}



struct FXPane_Previews: PreviewProvider {
    static var previews: some View {
        FXPane(isFXPanePresented: .constant(true)).environmentObject(mockData)
        .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        .previewDisplayName("iPhone X")
    }
}
