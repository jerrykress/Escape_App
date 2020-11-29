//
//  EscapeApp.swift
//  Escape
//
//  Created by Jerry Kress on 02/11/2020.
//

import SwiftUI

@main
struct EscapeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    let persistenceController = PersistenceController.shared
    let defaults = UserDefaults.standard

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("scene is now active!")
            case .inactive:
                print("scene is now inactive!")
            case .background:
                print("scene is now in the background!")
            @unknown default:
                print("Apple must have added something new!")
                
            }
        }
    }
}


// Runtime Mock User Data
let userData = UserData(
    allScenes: [
        SoundScene(title: "Ocean",
                   description: "The sound of ocean waves",
                   soundURL: "Ocean",
                   coverURL: "Cover_Ocean",
                   length: 100),
        SoundScene(title: "Dunes",
                   description: "The sound of ocean waves",
                   soundURL: "Fan",
                   coverURL: "Cover_Dunes",
                   length: 100),
        SoundScene(title: "Cosmos",
                   description: "The sound of ocean waves",
                   soundURL: "Rain",
                   coverURL: "Cover_Cosmos",
                   length: 100)
    ],
    allEffects: [
        SoundEffect(title: "Fireplace", iconURL: "flame", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Thunder Storm", iconURL: "bolt.fill", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Mountain Wind", iconURL: "wind", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Spring Rain", iconURL: "cloud.drizzle", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Winter Snow", iconURL: "snow", fileURL: "https://example.aac", volume: 0),
        SoundEffect(title: "Rail Road", iconURL: "tram.fill", fileURL: "https://example.aac", volume: 0)
    ]
)
