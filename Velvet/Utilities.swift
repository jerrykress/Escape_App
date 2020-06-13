//
//  Utilities.swift
//  Velvet
//
//  Created by Jerry Kress on 11/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import Foundation
import SwiftUI


extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}


extension LinearGradient {
    init(_ colors : Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


struct PathToShape: Shape {
    let path: Path
    
    func path(in rect: CGRect) -> Path {
        let bounds = path.boundingRect
        return path.applying(
            CGAffineTransform(scaleX: rect.size.width/bounds.size.width, y: rect.size.height/bounds.size.height)
        )
    }
}


class UserData: ObservableObject {
    @Published var allScenes: [SoundScene]
    @Published var currentTrackIndex: Int
    @Published var idx: Array<Int>
    
    init(allScenes: [SoundScene]) {
        self.allScenes = allScenes
        self.currentTrackIndex = 0
        self.idx = Array(0..<allScenes.count)
    }
}
