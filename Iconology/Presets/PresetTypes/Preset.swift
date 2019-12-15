//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

protocol Preset {
    var name: String { get }
    var folderName: String { get }
    var useModifications: UseModifications { get }
    var aspect: NSSize { get }

    func save(_ image: NSImage, at url: URL, with prefix: String)
}

protocol Size {
    var name: String { get }
}

struct UseModifications {
    var background: Bool
    var scale: Bool
    var shift: Bool
    var round: Bool
    var prefix: Bool

    init(background: Bool, scale: Bool, shift: Bool, round: Bool, prefix: Bool) {
        self.background = background
        self.scale = scale
        self.shift = shift
        self.round = round
        self.prefix = prefix
    }

    init() {
        background = true
        scale = true
        shift = true
        round = true
        prefix = true
    }
}
