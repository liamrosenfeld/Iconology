//
//  ImgSetPreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

class ImgSetPreset: Preset {
    var name: String
    var sizes: [ImgSetSize]
    var folderName = "Icons"
    var useModifications = UseModifications()
    var aspect: NSSize

    func save(_ image: NSImage, at url: URL, with prefix: String) {
        savePngs(image, at: url, with: prefix, in: sizes)
    }

    init(name: String, sizes: [ImgSetPreset.ImgSetSize], aspect: NSSize? = nil) {
        self.name = name
        self.sizes = sizes
        self.aspect = aspect ?? NSSize(width: 1, height: 1)
    }

    struct ImgSetSize: Size, Codable {
        var name: String
        var size: NSSize

        //swiftlint:disable identifier_name
        init(name: String, w: Int, h: Int) {
            self.name = name
            size = NSSize(width: w, height: h)
        }

        init(name: String, size: NSSize) {
            self.name = name
            self.size = size
        }
    }
}
