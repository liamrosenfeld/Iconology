//
//  IconsetSizes.swift
//  Iconology
//
//  Created by Liam on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

// https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html
let macIconset = [
    ImgSetPreset.ImgSetSize(name: "icon_16x16", x: 16, y: 16),
    ImgSetPreset.ImgSetSize(name: "icon_16x16@2x", x: 32, y: 32),
    ImgSetPreset.ImgSetSize(name: "icon_32x32", x: 32, y: 32),
    ImgSetPreset.ImgSetSize(name: "icon_32x32@2x", x: 64, y: 64),
    ImgSetPreset.ImgSetSize(name: "icon_128x128", x: 128, y: 128),
    ImgSetPreset.ImgSetSize(name: "icon_128x128@2x", x: 256, y: 256),
    ImgSetPreset.ImgSetSize(name: "icon_256x256", x: 256, y: 256),
    ImgSetPreset.ImgSetSize(name: "icon_256x256@2x", x: 512, y: 512),
    ImgSetPreset.ImgSetSize(name: "icon_512x512", x: 512, y: 512),
    ImgSetPreset.ImgSetSize(name: "icon_512x512@2x", x: 1024, y: 1024)
]

// https://docs.microsoft.com/en-us/windows/desktop/uxguide/vis-icons
let winIconset = [
    ImgSetPreset.ImgSetSize(name: "icon-16",  x: 16, y: 16),
    ImgSetPreset.ImgSetSize(name: "icon-32",  x: 32, y: 32),
    ImgSetPreset.ImgSetSize(name: "icon-48",  x: 48, y: 48),
    ImgSetPreset.ImgSetSize(name: "icon-64",  x: 64, y: 64)
]

// https://github.com/audreyr/favicon-cheat-sheet
let faviconIcoSet = [
    ImgSetPreset.ImgSetSize(name: "favicon-16", x: 16, y: 16),
    ImgSetPreset.ImgSetSize(name: "favicon-32", x: 32, y: 32),
    ImgSetPreset.ImgSetSize(name: "favicon-48", x: 48, y: 48)
]

let faviconSet = [
    ImgSetPreset.ImgSetSize(name: "favicon-16", x: 16, y: 16),
    ImgSetPreset.ImgSetSize(name: "favicon-32", x: 32, y: 32),
    ImgSetPreset.ImgSetSize(name: "favicon-57", x: 57, y: 57),
    ImgSetPreset.ImgSetSize(name: "favicon-76", x: 76, y: 76),
    ImgSetPreset.ImgSetSize(name: "favicon-96", x: 96, y: 96),
    ImgSetPreset.ImgSetSize(name: "favicon-120", x: 120, y: 120),
    ImgSetPreset.ImgSetSize(name: "favicon-128", x: 128, y: 128),
    ImgSetPreset.ImgSetSize(name: "favicon-144", x: 144, y: 144),
    ImgSetPreset.ImgSetSize(name: "favicon-152", x: 152, y: 152),
    ImgSetPreset.ImgSetSize(name: "favicon-180", x: 180, y: 180),
    ImgSetPreset.ImgSetSize(name: "favicon-195", x: 195, y: 195),
    ImgSetPreset.ImgSetSize(name: "favicon-196", x: 196, y: 196),
    ImgSetPreset.ImgSetSize(name: "favicon-228", x: 228, y: 228)
]
