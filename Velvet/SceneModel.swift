//
//  SceneModel.swift
//  Velvet
//
//  Created by Jerry Kress on 11/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import Foundation
import SwiftUI


struct SoundScene {
    let title: String
    let description: String
    let soundURL: String
    let coverURL: String
    let length: Int
}


extension SoundScene {
    static let allScenes: [SoundScene] = [
        SoundScene(title: "Ocean",
                   description: "Sleep to the sound of ocean waves",
                   soundURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   coverURL: "https://iphone-wallpaper.pics/wallpaper/1/6/163847_71bd70b6506e4845849a3a5d2b7a7413_raw.jpg",
                   length: 100),
        SoundScene(title: "Ecstacy",
                   description: "Sleep to the sound of mountain wind",
                   soundURL: "https://images.ctfassets.net/ooa29xqb8tix/6NCSjAxuA8EaEgkauQuKso/e3b1c4f38fa5e3899ca0f6d9c98370cd/iPhone_X_Wallpaper_9.png",
                   coverURL: "https://images.ctfassets.net/ooa29xqb8tix/6NCSjAxuA8EaEgkauQuKso/e3b1c4f38fa5e3899ca0f6d9c98370cd/iPhone_X_Wallpaper_9.png",
                   length: 100),
        SoundScene(title: "Mountain",
                   description: "Sleep to the sound of mountain wind",
                   soundURL: "https://i.pinimg.com/564x/d2/14/be/d214bed6bb5066408070ad70925ab72b.jpg",
                   coverURL: "https://i.pinimg.com/564x/d2/14/be/d214bed6bb5066408070ad70925ab72b.jpg",
                   length: 100)
    ]
}
