//
//  SceneCardView.swift
//  Velvet
//
//  Created by Jerry Kress on 04/07/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import URLImage

struct SceneCardView: View {
    @EnvironmentObject var userData: UserData
    @State var cardIndex: Int
    
    var body: some View {
        GeometryReader { proxy in
            
            // Outer Frame
            ZStack {
                
                // Inner Frame
                ZStack {
                    
                    // Cover Image
                    URLImage(URL(string: self.userData.allScenes[self.cardIndex].coverURL)!,
                             expireAfter: Date(timeIntervalSinceNow: 31_556_926.0),
                             content: {
                                  $0.image
                                    .resizable()
                             })
                    
                    // Title
                    Text(self.userData.allScenes[self.cardIndex].title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .foregroundColor(Color.white)
                        .font(.custom("DIN Alternate", size: 40))
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
            }
            .frame(width: proxy.size.width, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}


struct TestSceneCard: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        GeometryReader { proxy in
            
            ScrollView {
                LazyVStack {
                    ForEach(self.userData.allScenes.indices) { idx in
                        SceneCardView(cardIndex: idx)
                            .frame(width: proxy.size.width, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}


struct SceneCardView_Previews: PreviewProvider {
    static var previews: some View {
        TestSceneCard().environmentObject(mockData)
    }
}
