//
//  ScenePlayButtonHandler.swift
//  Velvet
//
//  Created by Jerry Kress on 03/09/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct ScenePlayButtonHandler: View {
    @EnvironmentObject var userData: UserData
    @Binding var isSessionViewPresented: Bool
    @Binding var isSessionReady: Bool
    @State var downloadStatus: Bool = false
    
    
    var body: some View {
        Button(action: {
            // Enter session if the sound file is already downloaded
            if (self.userData.getSceneByIndex(index: self.userData.currentTrackIndex).downloaded) {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.isSessionViewPresented.toggle() // Start Session
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Delay
                        self.isSessionReady = false // Restore Image to Full Size
                    }
                }
            }
            
            // Else download the file
            else {
                
                self.userData.allScenes[self.userData.currentTrackIndex].downloaded.toggle()
                self.downloadStatus.toggle()
            }
        }) {
            VStack {
                Image(systemName: downloadStatus ? "livephoto" : "square.and.arrow.down")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.white)
                    
                Text(downloadStatus ? "Play" : "Download")
                    .foregroundColor(.white)
                    .padding(.top, 10)
            }
        }
        .onAppear(perform: {
            downloadStatus = self.userData.getSceneByIndex(index: self.userData.currentTrackIndex).downloaded
        })

    }
}


struct TestScenePlayButtonHandler: View {
    @EnvironmentObject var userData: UserData
    @State var isSessionViewPresented: Bool = false
    @State var isSessionReady: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
            ScenePlayButtonHandler(isSessionViewPresented: self.$isSessionViewPresented, isSessionReady: self.$isSessionReady)
        }
        .frame(width: 100, height: 100, alignment: .center)
        
    }
}

struct ScenePlayButtonHandler_Previews: PreviewProvider {
    static var previews: some View {
        TestScenePlayButtonHandler()
            .environmentObject(mockData)
    }
}
