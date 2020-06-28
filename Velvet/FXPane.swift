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

    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black)
                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.offWhite, lineWidth: 2))
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 80)
                .opacity(0.3)
            

            VStack {
                Text("\(effect.title)")
                    .foregroundColor(Color.white)
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 10, alignment: .topLeading)
                    .padding(.top, 10)
                    .padding(.leading, 12)
                    .opacity(0.5)
                
                CustomSlider(value: $effect.volume, range: (0, 100), knobWidth: 25) { modifiers in
                  ZStack {
                    //Slider Body
                    Group {
                      //Highlighted Section
                      LinearGradient(gradient: .init(colors: [Color.blue, Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing)
                        .frame(height: 5)
                        .cornerRadius(2)
                        .modifier(modifiers.barLeft)
                      //Dimmed Section
                      Color.white
                        .opacity(0.2)
                        .frame(height: 5)
                        .cornerRadius(2)
                        .modifier(modifiers.barRight)
                      
                    }
                    .cornerRadius(2.5)
                    
                    //Slider Knob
                    Group {
                        Circle()
                            .fill(Color.black)
                            .overlay(Circle().stroke(Color.gray))
                        
                        Image(systemName: self.effect.iconURL).resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color.gray)
                    }
                    .frame(width: 25, height: 25)
                    .modifier(modifiers.knob)
                  }

                }
                .frame(height: 20)
                .padding(.top, 9)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.bottom, 12)
               
            }
        }
        .padding(6)
        .listRowBackground(Color.black)
        
    }
}

struct FXPane: View {
    @EnvironmentObject var userData: UserData
    @Binding var isFXPanePresented: Bool
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: Effect List
                List(self.userData.allEffects.indices) { idx in
                    FXRowView(effect: self.$userData.allEffects[idx])
                    
                }
                .onAppear(perform: {
                    // Set List background to black
                    UITableView.appearance().separatorColor = .black
                    UITableView.appearance().backgroundColor = .black
                    UITableViewCell.appearance().backgroundColor = .black
                })
                    .frame(maxWidth: proxy.size.width, minHeight: proxy.size.height, maxHeight: .infinity, alignment: .center)

                
                // MARK: Close Button
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
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
                .offset(x: 0, y: -proxy.size.height/10)
            }
            .padding(.top, 20)
        }

    }
}



struct FXPane_Previews: PreviewProvider {
    static var previews: some View {
        FXPane(isFXPanePresented: .constant(true)).environmentObject(mockData)
        .previewDevice(PreviewDevice(rawValue: "iPhone X"))
        .previewDisplayName("iPhone X")
    }
}
