//
//  CollectionPreset.swift
//  Iconology
//
//  Created by Liam on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

final class CollectionPreset: Preset {
    var name: String
    var subpresets: [Preset]
    var folderName: String = "Icons"
    var usePrefix: Bool = false
    
    func save(_ image: NSImage, at url: URL, with prefix: String) {
        saveCollection(image, at: url, in: subpresets)
    }
    
    init(name: String, subpresets: [Preset]) {
        self.name = name
        self.subpresets = subpresets
    }
    
}
