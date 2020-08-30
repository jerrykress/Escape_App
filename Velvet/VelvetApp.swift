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
    @Environment(\.scenePhase) private var scenePhase
    
    // Create Data Management Context
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Create Persistant Data Stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SoundSceneData")
    
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) ")
            }
        })
        return container
    }()
    
    // When App First Launch
    init() {
        for scene in userData.getAllScene() {
            print("Init scene: \(scene.title)")
            
            // Create data in context
            guard let sceneData = NSEntityDescription.insertNewObject(forEntityName: "SoundSceneData", into: context) as? SoundSceneData else {
              return
            }
            
            // Copy Attributes
            sceneData.title = scene.title
            sceneData.coverURL = scene.coverURL
            sceneData.soundURL = scene.soundURL
            
            // Cover Download
            let coverURL = URL(string: scene.coverURL)!
            
            let coverDownload = URLSession.shared.downloadTask(with: coverURL) { localURL, urlResponse, error in
                print("Scene \(scene.title): Cover tmp path -> \(localURL!)")
                guard let fileURL = localURL else { return }
                    do {
                        let documentsURL = try
                            FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
                        let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                        print("Scene \(scene.title): Cover saved path -> \(savedURL)")
                        sceneData.coverLocalURL = savedURL
                        try FileManager.default.moveItem(at: fileURL, to: savedURL)
                    } catch {
                        print ("file error: \(error)")
                    }
                
            }
            
            coverDownload.resume()
            
            // Sound Download
            let soundURL = URL(string: scene.soundURL)!
            
            let soundDownload = URLSession.shared.downloadTask(with: soundURL) { localURL, urlResponse, error in
                print("Scene \(scene.title): Sound tmp path -> \(localURL!)")
                guard let fileURL = localURL else { return }
                    do {
                        let documentsURL = try
                            FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
                        let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                        print("Scene \(scene.title): Sound saved path -> \(savedURL)")
                        sceneData.soundLocalURL = savedURL
                        try FileManager.default.moveItem(at: fileURL, to: savedURL)
                    } catch {
                        print ("file error: \(error)")
                    }
                
            }
            
            soundDownload.resume()
            
            
            // Saving to Core Data
            saveContext()
            
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environment(\.managedObjectContext, context)
        }
        .onChange(of: scenePhase) { phase in
            if (phase == .background) {
                // Save When App Enters Background
                saveContext()
            }
            
        }
    }

    
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
