//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

struct Preset: Hashable, Codable {
    var name: String
    var type: PresetType
    var aspect: CGSize
    var useModifications: EnabledModifications
    
    func save(_ image: CGImage) -> URL? {
        type.save(image)
    }

    init(name: String, type: PresetType, aspect: NSSize, useModifications: EnabledModifications) {
        self.name = name
        self.type = type
        self.aspect = aspect
        self.useModifications = useModifications
    }

    init(name: String, type: PresetType, useModifications: EnabledModifications) {
        self.name = name
        self.type = type
        self.aspect = CGSize(width: 1, height: 1)
        self.useModifications = useModifications
    }
}

struct EnabledModifications: Hashable, Codable {
    var background: Bool
    var scale: Bool
    var shift: Bool
    var round: Bool
    var padding: Bool
    var shadow: Bool

    static func all() -> Self {
        EnabledModifications(
            background: true,
            scale: true,
            shift: true,
            round: true,
            padding: true,
            shadow: true
        )
    }

    static func limitedXcode() -> Self {
        EnabledModifications(
            background: true,
            scale: true,
            shift: true,
            round: false,
            padding: false,
            shadow: false
        )
    }
}
