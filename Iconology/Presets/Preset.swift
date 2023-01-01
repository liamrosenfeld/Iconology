//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics
import Foundation

protocol Preset: Identifiable, Hashable {
    var name: String { get set }
    var aspect: CGSize { get set }
    var enabledModifications: EnabledModifications { get set }
    
    /// max size that preset will generate. nil if size provided by generator
    var maxSize: CGSize? { get }
    
    var id: UUID { get }
    
    func save(_ image: CGImage) -> URL?
}

struct EnabledModifications: Hashable, Codable {
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
