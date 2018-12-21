//
//  ImgSetPreset.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

class ImgSetPreset: Preset {
    var name: String
    var sizes: [ImgSetSize]
    var folderName = "Icons"
    var usePrefix: Bool
    
    func save(_ image: NSImage, at url: URL, with prefix: String) {
        savePng(image, at: url, with: prefix, in: sizes)
    }
    
    init(name: String, sizes: [ImgSetPreset.ImgSetSize], usePrefix: Bool) {
        self.name = name
        self.sizes = sizes
        self.usePrefix = usePrefix
    }
    
    struct ImgSetSize: Size, Codable {
        var name: String
        var x: Int
        var y: Int
    }
}


