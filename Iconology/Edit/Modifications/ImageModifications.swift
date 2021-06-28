//
//  ImageModifications.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/8/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit
import Combine

typealias ShadowAttributes = (opacity: CGFloat, blur: CGFloat)

class ImageModifications: ObservableObject {
    @Published var aspect: CGSize
    @Published var scale: CGFloat
    @Published var shift: CGPoint
    @Published var background: CGColor
    @Published var useBackground: Bool
    @Published var rounding: CGFloat
    @Published var padding: CGFloat
    @Published var shadow: ShadowAttributes

    init() {
        aspect = CGSize(width: 1, height: 1)
        scale = 100
        shift = .zero
        background = .white
        useBackground = false
        rounding = 0
        padding = 0
        shadow = (0, 0)
    }
}
