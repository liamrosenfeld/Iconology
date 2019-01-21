//
//  ExamplePresets.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct ExamplePresets {
    static func addExamplePresets() {
        Presets.userPresets.addPreset(name: "Powers of Two", sizes: powersOfTwo, usePrefix: true)
        Presets.userPresets.savePresets()
    }
    
    static let powersOfTwo = [
        ImgSetPreset.ImgSetSize(name: "16", x: 16, y: 16),
        ImgSetPreset.ImgSetSize(name: "24", x: 24, y: 24),
        ImgSetPreset.ImgSetSize(name: "32", x: 32, y: 32),
        ImgSetPreset.ImgSetSize(name: "48", x: 48, y: 48),
        ImgSetPreset.ImgSetSize(name: "64", x: 64, y: 64),
        ImgSetPreset.ImgSetSize(name: "96", x: 96, y: 96),
        ImgSetPreset.ImgSetSize(name: "128", x: 128, y: 128),
        ImgSetPreset.ImgSetSize(name: "512", x: 512, y: 512),
        ImgSetPreset.ImgSetSize(name: "1024", x: 1024, y: 1024),
        ImgSetPreset.ImgSetSize(name: "2048", x: 2048, y: 2048)
    ]
}
