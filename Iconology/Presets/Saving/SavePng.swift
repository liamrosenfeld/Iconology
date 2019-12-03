//
//  SavePng.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func savePngs(_ image: NSImage, at url: URL, with prefix: String, in sizes: [ImgSetPreset.ImgSetSize]) {
    for size in sizes {
        let resizedImage = image.resize(to: size.size)
        let name = "\(prefix)\(size.name)"
        savePng(resizedImage, named: name, at: url)
    }
}

func savePng(_ image: NSImage, named name: String, at url: URL) {
    let url = url.appendingPathComponent("\(name).png")
    do {
        try image.savePng(to: url)
    } catch {
        print("ERR: \(error)")
    }
}

extension NSImage {
    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }
        return nil
    }
    
    func savePng(to url: URL) throws {
        guard let png = self.PNGRepresentation else {
            throw NSImageError.unwrapPNGFailed
        }
        try png.write(to: url, options: .atomicWrite)
    }
    
    enum NSImageError: Error {
        case unwrapPNGFailed
    }
}
