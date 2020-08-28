//
//  AppDelegate.swift
//  Velvet
//
//  Created by Jerry Kress on 02/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI
import CoreData

@main
struct Velvet: App {
    
    // Define NSManagedObjectContext
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Inject NSManagedObjectContext into SwiftUI Env
    // Inject User Data
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environment(\.managedObjectContext, context)
        }
    }
    
    // Create Persistant Data Model
    var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SoundDataModel")
        
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo) ")
                }
            })
            return container
        }()

    
    // Save Data Change
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


// Runtime Mock User Data
let userData = UserData(
    allScenes: [
        SoundScene(title: "Ocean",
                   description: "The sound of ocean waves",
                   soundURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   coverURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   length: 100),
        SoundScene(title: "Dunes",
                   description: "The sound of ocean waves",
                   soundURL: "https://wallpaperplay.com/walls/full/8/0/6/114384.jpg",
                   coverURL: "https://wallpaperplay.com/walls/full/8/0/6/114384.jpg",
                   length: 100),
        SoundScene(title: "Cosmos",
                   description: "The sound of ocean waves",
                   soundURL: "https://wallpapercave.com/wp/wp4570367.jpg",
                   coverURL: "https://wallpapercave.com/wp/wp4570367.jpg",
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
