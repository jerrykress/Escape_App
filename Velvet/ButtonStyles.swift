//
//  ButtonStyles.swift
//  Velvet
//
//  Created by Jerry Kress on 11/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import Foundation
import SwiftUI


struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 3))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)

            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 3))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct GlassBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.clear)
                    .background(Blur(style: .systemUltraThinMaterial))
                    .mask(Circle())
            } else {
                shape
                    .fill(Color.clear)
                    .background(Blur(style: .systemUltraThinMaterial))
                    .mask(Circle())
            }
        }
    }
}

struct NoFillBorderBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color.black)
                    .overlay(shape.stroke(Color.offWhite, lineWidth: 1))
                    .opacity(0.5)
            } else {
                shape
                    .fill(Color.black)
                    .overlay(shape.stroke(Color.offWhite, lineWidth: 1))
                    .opacity(0.5)
            }
        }
    }
}


struct DarkNeumorphicRoundButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(30)
        .contentShape(Circle())
        .background(
            DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
        .animation(nil)
    }
}


struct BlurryRoundButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(25)
        .contentShape(Circle())
        .background(
            GlassBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct NoFillBorderButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding(20)
        .contentShape(Circle())
        .background(
            NoFillBorderBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
