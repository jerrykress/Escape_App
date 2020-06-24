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


class SoundEffect {
    @Published var title: String
    @Published var iconURL: String
    @Published var fileURL: String
    @Published var volume: Double
    
    init(title: String, iconURL: String, fileURL: String, volume:Double) {
        self.title = title
        self.iconURL = iconURL
        self.fileURL = fileURL
        self.volume = volume
    }
}
