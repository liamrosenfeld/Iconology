//
//  ImgSetSize.swift.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct ImgSetSize: Hashable, Codable, Identifiable {
    var name: String
    var size: CGSize
    
    var id = UUID()

    init(name: String, w: Int, h: Int) {
        self.name = name
        size = NSSize(width: w, height: h)
    }

    init(name: String, size: NSSize) {
        self.name = name
        self.size = size
    }
}

enum ImgSetSizes {
    // https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html
    static let macIconset = [
        ImgSetSize(name: "icon_16x16", w: 16, h: 16),
        ImgSetSize(name: "icon_16x16@2x", w: 32, h: 32),
        ImgSetSize(name: "icon_32x32", w: 32, h: 32),
        ImgSetSize(name: "icon_32x32@2x", w: 64, h: 64),
        ImgSetSize(name: "icon_128x128", w: 128, h: 128),
        ImgSetSize(name: "icon_128x128@2x", w: 256, h: 256),
        ImgSetSize(name: "icon_256x256", w: 256, h: 256),
        ImgSetSize(name: "icon_256x256@2x", w: 512, h: 512),
        ImgSetSize(name: "icon_512x512", w: 512, h: 512),
        ImgSetSize(name: "icon_512x512@2x", w: 1024, h: 1024)
    ]

    // https://github.com/audreyr/favicon-cheat-sheet
    static let faviconSet = [
        ImgSetSize(name: "favicon-16", w: 16, h: 16),
        ImgSetSize(name: "favicon-32", w: 32, h: 32),
        ImgSetSize(name: "favicon-57", w: 57, h: 57),
        ImgSetSize(name: "favicon-76", w: 76, h: 76),
        ImgSetSize(name: "favicon-96", w: 96, h: 96),
        ImgSetSize(name: "favicon-120", w: 120, h: 120),
        ImgSetSize(name: "favicon-128", w: 128, h: 128),
        ImgSetSize(name: "favicon-144", w: 144, h: 144),
        ImgSetSize(name: "favicon-152", w: 152, h: 152),
        ImgSetSize(name: "favicon-180", w: 180, h: 180),
        ImgSetSize(name: "favicon-195", w: 195, h: 195),
        ImgSetSize(name: "favicon-196", w: 196, h: 196),
        ImgSetSize(name: "favicon-228", w: 228, h: 228)
    ]
}
