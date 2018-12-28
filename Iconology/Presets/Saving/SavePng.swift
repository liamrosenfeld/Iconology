//
//  SavePng.swift
//  Iconology
//
//  Created by Liam on 6/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func savePng(_ image: NSImage, at url: URL, with prefix: String, in sizes: [ImgSetPreset.ImgSetSize]) {
    for size in sizes {
        let resizedImage = image.resize(w: size.x, h: size.y)
        let name = "\(prefix)\(size.name)"
        let url = url.appendingPathComponent("\(name).png")
        do {
            try resizedImage.savePng(to: url)
        } catch {
            print("ERR: \(error)")
        }
    }
}

