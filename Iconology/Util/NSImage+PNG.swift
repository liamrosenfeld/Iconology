//
//  NSImage+PNG.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

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
