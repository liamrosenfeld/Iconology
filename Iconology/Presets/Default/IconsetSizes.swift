//
//  IconsetSizes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
// https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html
let macIconset = [
    ImgSetPreset.ImgSetSize(name: "icon_16x16", w: 16, h: 16),
    ImgSetPreset.ImgSetSize(name: "icon_16x16@2x", w: 32, h: 32),
    ImgSetPreset.ImgSetSize(name: "icon_32x32", w: 32, h: 32),
    ImgSetPreset.ImgSetSize(name: "icon_32x32@2x", w: 64, h: 64),
    ImgSetPreset.ImgSetSize(name: "icon_128x128", w: 128, h: 128),
    ImgSetPreset.ImgSetSize(name: "icon_128x128@2x", w: 256, h: 256),
    ImgSetPreset.ImgSetSize(name: "icon_256x256", w: 256, h: 256),
    ImgSetPreset.ImgSetSize(name: "icon_256x256@2x", w: 512, h: 512),
    ImgSetPreset.ImgSetSize(name: "icon_512x512", w: 512, h: 512),
    ImgSetPreset.ImgSetSize(name: "icon_512x512@2x", w: 1024, h: 1024)
]

// https://docs.microsoft.com/en-us/windows/desktop/uxguide/vis-icons
let winIconset = [
    ImgSetPreset.ImgSetSize(name: "icon-16", w: 16, h: 16),
    ImgSetPreset.ImgSetSize(name: "icon-32", w: 32, h: 32),
    ImgSetPreset.ImgSetSize(name: "icon-48", w: 48, h: 48),
    ImgSetPreset.ImgSetSize(name: "icon-64", w: 64, h: 64)
]

// https://github.com/audreyr/favicon-cheat-sheet
let faviconIcoSet = [
    ImgSetPreset.ImgSetSize(name: "favicon-16", w: 16, h: 16),
    ImgSetPreset.ImgSetSize(name: "favicon-32", w: 32, h: 32),
    ImgSetPreset.ImgSetSize(name: "favicon-48", w: 48, h: 48)
]

let faviconSet = [
    ImgSetPreset.ImgSetSize(name: "favicon-16", w: 16, h: 16),
    ImgSetPreset.ImgSetSize(name: "favicon-32", w: 32, h: 32),
    ImgSetPreset.ImgSetSize(name: "favicon-57", w: 57, h: 57),
    ImgSetPreset.ImgSetSize(name: "favicon-76", w: 76, h: 76),
    ImgSetPreset.ImgSetSize(name: "favicon-96", w: 96, h: 96),
    ImgSetPreset.ImgSetSize(name: "favicon-120", w: 120, h: 120),
    ImgSetPreset.ImgSetSize(name: "favicon-128", w: 128, h: 128),
    ImgSetPreset.ImgSetSize(name: "favicon-144", w: 144, h: 144),
    ImgSetPreset.ImgSetSize(name: "favicon-152", w: 152, h: 152),
    ImgSetPreset.ImgSetSize(name: "favicon-180", w: 180, h: 180),
    ImgSetPreset.ImgSetSize(name: "favicon-195", w: 195, h: 195),
    ImgSetPreset.ImgSetSize(name: "favicon-196", w: 196, h: 196),
    ImgSetPreset.ImgSetSize(name: "favicon-228", w: 228, h: 228)
]
