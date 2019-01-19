//
//  FilePreset.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

final class FilePreset: Preset {
    var name: String
    var filetype: FilePreset.Filetype
    var folderName = ""
    var usePrefix: Bool
    var sizes: [ImgSetPreset.ImgSetSize]
    var aspect: NSSize
    
    func save(_ image: NSImage, at url: URL, with prefix: String) {
        saveFile(image, at: url, as: filetype)
    }
    
    init(name: String, filetype: FilePreset.Filetype, sizes: [ImgSetPreset.ImgSetSize], usePrefix: Bool, aspect: NSSize? = nil) {
        self.name = name
        self.filetype = filetype
        self.sizes = sizes
        self.usePrefix = usePrefix
        self.aspect = aspect ?? NSSize(width: 1, height: 1)
    }
    
    enum Filetype: String {
        case icns
        case ico
    }
}


