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
                .padding(.top, 4)
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.bottom, 10)
               
            }
        }
        .padding(5)
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
