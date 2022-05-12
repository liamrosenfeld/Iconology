//
//  ImageModifications.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/8/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit
import Combine

class ImageModifications: ObservableObject {
    @Published var size: CGSize
    @Published var scale: CGFloat
    @Published var shift: CGPoint
    @Published var background: Background
    @Published var rounding: Rounding
    @Published var padding: CGFloat
    @Published var shadow: ShadowAttributes

    init() {
        size = CGSize(width: 100, height: 100)
        scale = 100
        shift = .zero
        background = .none
        rounding = (0, .circular)
        padding = 0
        shadow = (0, 0)
    }
}

enum RoundingStyle {
    case circular
    case continuous
    case squircle
}

typealias Rounding = (percent: CGFloat, style: RoundingStyle)

typealias ShadowAttributes = (opacity: CGFloat, blur: CGFloat)
