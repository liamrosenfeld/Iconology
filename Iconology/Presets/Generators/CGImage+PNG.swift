//
//  CGImage+PNG.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/22/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

extension CGImage {
    func savePng(to url: URL) throws {
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
            throw SaveError.destinationFailed
        }
        CGImageDestinationAddImage(destination, self, nil)
        if !CGImageDestinationFinalize(destination) {
            throw SaveError.saveFailed
        }
    }
    
    var pngRepresentation: Data? {
        let tiffData = NSBitmapImageRep(cgImage: self)
        return tiffData.representation(using: .png, properties: [:])
    }
    
    enum SaveError: Error {
        case destinationFailed
        case saveFailed
    }
}
