//
//  FilePreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

final class FilePreset: Preset {
    var name: String
    var filetype: FilePreset.Filetype
    var folderName = ""
    var useModifications: UseModifications
    var aspect: NSSize

    func save(_ image: NSImage, at url: URL, with _: String) {
        saveFile(image, at: url, as: filetype)
    }

    init(name: String, filetype: FilePreset.Filetype, prefix: Bool, aspect: NSSize? = nil) {
        self.name = name
        self.filetype = filetype
        useModifications = UseModifications(background: true, scale: true, shift: true, round: true, padding: true, prefix: prefix)
        self.aspect = aspect ?? NSSize(width: 1, height: 1)
    }

    enum Filetype {
        case png
        case icns
        case ico([ImgSetPreset.ImgSetSize])
    }
}
