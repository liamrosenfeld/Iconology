//
//  SaveCollection.swift
//  Iconology
//
//  Created by Liam on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

func saveCollection(_ image: NSImage, at url: URL, in presets: [Preset]) {
    for preset in presets {
        preset.save(image, at: url, with: "")
    }
}
