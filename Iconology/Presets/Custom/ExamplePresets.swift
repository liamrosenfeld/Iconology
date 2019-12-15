//
//  ExamplePresets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct ExamplePresets {
    static func addExamplePresets() {
        Storage.userPresets.addPreset(name: "Powers of Two", sizes: powersOfTwo, prefix: true)
        Storage.userPresets.savePresets()
    }

    static let powersOfTwo = [
        ImgSetPreset.ImgSetSize(name: "16", w: 16, h: 16),
        ImgSetPreset.ImgSetSize(name: "24", w: 24, h: 24),
        ImgSetPreset.ImgSetSize(name: "32", w: 32, h: 32),
        ImgSetPreset.ImgSetSize(name: "48", w: 48, h: 48),
        ImgSetPreset.ImgSetSize(name: "64", w: 64, h: 64),
        ImgSetPreset.ImgSetSize(name: "96", w: 96, h: 96),
        ImgSetPreset.ImgSetSize(name: "128", w: 128, h: 128),
        ImgSetPreset.ImgSetSize(name: "512", w: 512, h: 512),
        ImgSetPreset.ImgSetSize(name: "1024", w: 1024, h: 1024),
        ImgSetPreset.ImgSetSize(name: "2048", w: 2048, h: 2048)
    ]
}
