//
//  TwoDimensionSlider.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/9/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct TwoDimensionSlider: View {
    /// both x and y in [-100, 100]
    @Binding var position: CGPoint

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Color.white
                    .cornerRadius(5)
                Color.accentColor
                    .frame(width: 10, height: 10)
                    .mask(Circle())
                    .offset(
                        x: position.x * (geometry.size.width / 2) / 100,
                        y: position.y * (geometry.size.height / 2) / -100
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                // scale from pixel to percent
                                let newXPos = (gesture.location.x - 5) / (geometry.size.width / 2) * 100
                                let newYPos = (5 - gesture.location.y) / (geometry.size.height / 2) * 100
                                
                                // limit to [-100, 100]
                                self.position = CGPoint(
                                    x: (newXPos / abs(newXPos)) * min(abs(newXPos), 100),
                                    y: (newYPos / abs(newYPos)) * min(abs(newYPos), 100)
                                )
                            }
                    )
            }
        }
        .accessibilityLabel("Position selector")
        .accessibilityValue("\(position.x.toIntString()) x, \(position.y.toIntString()) y")
        .accessibilityActions {
            Button("Move up")    { position.y = min(100,  position.y + 10) }
            Button("Move down")  { position.y = max(-100, position.y - 10) }
            Button("Move right") { position.x = min(100,  position.x + 10) }
            Button("Move left")  { position.x = max(-100, position.x - 10) }
        }
    }
}

struct TwoDimensionSlider_Previews: PreviewProvider {
    @State static var position: CGPoint = .zero

    static var previews: some View {
        TwoDimensionSlider(position: $position)
            .frame(width: 200, height: 200)
    }
}
