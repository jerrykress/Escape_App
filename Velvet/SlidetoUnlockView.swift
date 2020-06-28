//
//  SlidetoUnlockView.swift
//  Velvet
//
//  Created by Jerry Kress on 26/06/2020.
//  Copyright © 2020 Jerry Kress. All rights reserved.
//

import SwiftUI

struct SlidetoUnlockView: View {
    
    // Public Property
    var sliderTopBottomPadding: CGFloat = 0
    var thumbnailTopBottomPadding: CGFloat = 0
    var thumbnailLeadingTrailingPadding: CGFloat = 0
    var textLabelLeadingPadding: CGFloat = 0
    var text: String = "End Session"
    var textFont: Font = .system(size: 20)
    var textFontWeight: Font.Weight = .regular
    var textColor = Color(.sRGB, red: 25.0/255, green: 155.0/255, blue: 215.0/255, opacity: 0.7)
    var thumbnailColor = Color(.sRGB, red: 25.0/255, green: 155.0/255, blue: 215.0/255, opacity: 1)
    var thumbnailBackgroundColor: Color = .clear
    var sliderBackgroundColor = Color.gray
    var resetAnimation: Animation = .easeIn(duration: 0.4)
    var iconName = "chevron.right"
    var didReachEndAction: ((SlidetoUnlockView) -> Void)?
    
    // Private Property
    @State private var draggableState: DraggableState = .ready
    
    private enum DraggableState {
        case ready
        case dragging(offsetX: CGFloat, maxX: CGFloat)
        case end(offsetX: CGFloat)
        
        var reachEnd: Bool {
            switch self {
            case .ready, .dragging(_,_):
                return false
            case .end(_):
                return true
            }
        }
        
        var isReady: Bool {
            switch self {
            case .dragging(_,_), .end(_):
                return false
            case .ready:
                return true
            }
        }
        
        var offsetX: CGFloat {
              switch self {
              case .ready:
                return 0.0
              case let .dragging(offsetX,_):
                  return offsetX
              case .end(let offsetX):
                  return offsetX
              }
          }
        
        var textColorOpacity: Double {
            switch self {
            case .ready:
                return 0.4
            case let .dragging(offsetX,maxX):
                return 0.4 - Double(offsetX / maxX)
            case .end(_):
                return 0.0
            }
        }
        
    }
    
    var body: some View {
        return GeometryReader { geometry in
            self.setupView(geometry: geometry)
        }
    }
    
    private func setupView(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .global)
        let width = frame.size.width
        let height = frame.size.height
        let drag = DragGesture()
            .onChanged({ (drag) in
                let maxX = width - height - self.thumbnailLeadingTrailingPadding * 2 + self.thumbnailTopBottomPadding * 2
                let currentX = drag.translation.width
                if currentX >= maxX {
                    self.draggableState = .end(offsetX: maxX)
                    self.didReachEndAction?(self)
                } else if currentX <= 0 {
                    self.draggableState = .dragging(offsetX: 0, maxX: maxX)
                } else {
                    self.draggableState = .dragging(offsetX: currentX, maxX: maxX)
                }
            })
            .onEnded(onDragEnded)
        let sliderCornerRadius = (height - sliderTopBottomPadding * 2) / 2
        return HStack {
                ZStack(alignment: .leading, content: {
                    HStack {
                        Text(self.text)
                        .font(self.textFont)
                        .fontWeight(self.textFontWeight)
                        .frame(maxWidth: .infinity)
                        .padding([.leading], textLabelLeadingPadding)
                        .foregroundColor(self.textColor)
                        .opacity(self.draggableState.textColorOpacity)
                        .animation(self.draggableState.isReady ? self.resetAnimation : nil)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(self.sliderBackgroundColor)
                    .cornerRadius(sliderCornerRadius)
                    .padding([.top, .bottom], self.sliderTopBottomPadding)
                    
                    Image(systemName: "\(self.iconName)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.0, contentMode: .fit)
                    .background(self.thumbnailColor.opacity(0.4))
                    .clipShape(Circle())
                    .padding([.top, .bottom], self.thumbnailTopBottomPadding)
                    .padding([.leading, .trailing], self.thumbnailLeadingTrailingPadding)
                    .background(self.thumbnailBackgroundColor)
                    .cornerRadius(sliderCornerRadius)
                    .offset(x: self.self.draggableState.offsetX)
                    .animation(self.draggableState.isReady ? self.resetAnimation : nil)
                    .gesture(self.draggableState.reachEnd ? nil : drag)
                  })
                }
                .background(Color.clear)

    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        switch draggableState {
        case .end(_), .dragging(_,_):
            draggableState = .ready
            break
        case .ready:
            break
        }
    }
    
    // MARK: Public Function
    
    func resetState(_ animated: Bool = true) {
        self.draggableState = .ready
    }
}


