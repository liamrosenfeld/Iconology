//
//  CollectionPreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

final class CollectionPreset: Preset {
    var name: String
    var subpresets: [Preset]
    var folderName: String = "Icons"
    var useModifications = UseModifications(background: true, scale: true, shift: true, round: true, prefix: true)
    var aspect: NSSize
    
    func save(_ image: NSImage, at url: URL, with prefix: String) {
        saveCollection(image, at: url, in: subpresets)
    }
    
    init(name: String, subpresets: [Preset], aspect: NSSize? = nil) {
        self.name = name
        self.subpresets = subpresets
        self.aspect = aspect ?? NSSize(width: 1, height: 1)
    }
    
}
