//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics
import Foundation

protocol Preset: Identifiable {
    var name: String { get set }
    var aspect: CGSize { get set }
    
    var enabledMods: EnabledModifications { get }
    var defaultMods: DefaultModifications { get }
    
    /// max size that preset will generate. nil if size provided by generator
    var maxSize: CGSize? { get }
    
    var id: UUID { get }
    
    func save(_ image: CGImage) -> URL?
}

struct EnabledModifications {
    var background: Bool
    var scale: Bool
    var shift: Bool
    var round: Bool
    var padding: Bool
    var shadow: Bool

    static let all = EnabledModifications(
        background: true,
        scale: true,
        shift: true,
        round: true,
        padding: true,
        shadow: true
    )

    static let limitedXcode = EnabledModifications(
        background: true,
        scale: true,
        shift: true,
        round: false,
        padding: false,
        shadow: false
    )
}

struct DefaultModifications {
    var background: Background
    var round: Rounding
    var padding: CGFloat
    var shadow: ShadowAttributes
    
    static let zeros = DefaultModifications(
        background: .none,
        round: (percent: 0, style: .circular),
        padding: 0,
        shadow: (opacity: 0, blur: 0)
    )
    
    static let macOS = DefaultModifications(
        background: .color(.white),
        round: (percent: 45, style: .continuous),
        padding: 19.5,
        shadow: (opacity: 30, blur: 24)
    )
    
    static let background = DefaultModifications(
        background: .color(.white),
        round: (percent: 0, style: .circular),
        padding: 0,
        shadow: (opacity: 0, blur: 0)
    )
}

extension CGSize {
    /// 1 by 1 unit square
    static let unit: CGSize = .init(width: 1, height: 1)
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(width)
    }
}
