//
//  UserDataModel.swift
//  Velvet
//
//  Created by Jerry Kress on 11/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import Foundation
import SwiftUI


/// A structure for user data. It contains all scenes and effects available to the user
class UserData: ObservableObject {
    @Published private var allScenes: [SoundScene]
    @Published public var allEffects: [SoundEffect]
    @Published public var currentTrackIndex: Int
    @Published public var timer: Int
    
    
    /// Create a new user data object
    /// - Parameters:
    ///   - allScenes: A list of SoundScene objects
    ///   - allEffects: A list of SoundEffect objects
    init(allScenes: [SoundScene], allEffects: [SoundEffect]) {
        self.allScenes = allScenes
        self.allEffects = allEffects
        self.currentTrackIndex = 0
        self.timer = 0
    }
    
    
    /// Add an additional scene to user data
    /// - Parameters:
    ///   - title: The title of the scene
    ///   - description: A short description of the scene
    ///   - soundURL: URL of the sound file
    ///   - coverURL: Name of scene image file
    ///   - length: Total length of the sound file in seconds
    public func addScene(title: String, description: String, soundURL: String, coverURL: String, length: Int) {
        let newScene: SoundScene = SoundScene(title: title, description: description, soundURL: soundURL, coverURL: coverURL, length: length)
        self.allScenes.append(newScene)
    }
    
    
    /// Add an additional effect to user data
    /// - Parameters:
    ///   - title: The title of the effect
    ///   - iconURL: The name of icon in SF Symbols
    ///   - fileURL: URL of effect sound file
    ///   - volume: The default volume of the effect (recommended 0)
    public func addEffect(title: String, iconURL: String, fileURL: String, volume:Double) {
        let newEffect: SoundEffect = SoundEffect(title: title, iconURL: iconURL, fileURL: fileURL, volume:volume)
        self.allEffects.append(newEffect)
    }
    
    
    /// Get a list of all scenes available to the user
    /// - Returns: A list of SoundScene Objects
    public func getAllScene() -> [SoundScene] {
        return self.allScenes
    }
    
    
    /// Get a specific scene available to the user
    /// - Parameter index: Scene index
    /// - Returns: SoundScene Object
    public func getSceneByIndex(index: Int) -> SoundScene {
        return self.allScenes[index]
    }
    
    
    /// Get the current active scene
    /// - Returns: SoundScene Object
    public func getCurrentScene() -> SoundScene {
        return self.allScenes[self.currentTrackIndex]
    }
}


/// The main sound played by the user
class SoundScene {
    @Published var title: String
    @Published var description: String
    @Published var soundURL: String
    @Published var coverURL: String
    @Published var length: Int
    
    var id: UUID
    
    init(title: String, description: String, soundURL: String, coverURL: String, length: Int) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.soundURL = soundURL
        self.coverURL = coverURL
        self.length = length
    }
}


/// An add-on sound that should be played on top of a scene
class SoundEffect {
    @Published var title: String
    @Published var iconURL: String
    @Published var fileURL: String
    @Published var volume: Double
    
    var id: UUID
    
    init(title: String, iconURL: String, fileURL: String, volume:Double) {
        self.id = UUID()
        self.title = title
        self.iconURL = iconURL
        self.fileURL = fileURL
        self.volume = volume
    }
}
