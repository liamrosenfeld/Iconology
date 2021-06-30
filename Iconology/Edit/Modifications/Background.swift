//
//  Background.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/30/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation

enum Background {
    case none
    case color(CGColor)
    case gradient(Gradient)
}

struct Gradient: Hashable {
    var angle: CGFloat
    var topColor: CGColor
    var bottomColor: CGColor
    
    static let `default` = Gradient(angle: 0, topColor: .white, bottomColor: .white)
    
    var cgGradient: CGGradient {
        CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [topColor, bottomColor] as CFArray,
            locations: [0, 1]
        )!
    }
}

extension Background: Hashable {
    // ignore associated value when comparing
    // allows swiftui picker to work
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case (.color(_), .color(_)):
            return true
        case (.gradient(_), .gradient(_)):
            return true
        default:
            return false
        }
    }
}

// Binding Support
extension Background {
    var color: CGColor {
        get {
            switch self {
            case .color(let color):
                return color
            default:
                print("WARN: getting color when not supposed to")
                return .white
            }
        }
        set {
            switch self {
            case .color:
                self = .color(newValue)
            default:
                print("WARN: setting color when not supposed to")
            }
        }
    }
    
    var gradient: Gradient {
        get {
            switch self {
            case .gradient(let gradient):
                return gradient
            default:
                print("WARN: getting gradient when not supposed to")
                return .default
            }
        }
        set {
            switch self {
            case .gradient:
                self = .gradient(newValue)
            default:
                print("WARN: setting gradient when not supposed to")
            }
        }
    }
}
