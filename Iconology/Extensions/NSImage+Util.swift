//
//  NSImage+Data.swift
//  Iconology
//
//  Created by Liam on 12/22/18.
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
    
    func resize(w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(destSize.width), pixelsHigh: Int(destSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)
        rep?.size = destSize
        NSGraphicsContext.saveGraphicsState()
        if let aRep = rep {
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: aRep)
        }
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: destSize)
        if let aRep = rep {
            newImage.addRepresentation(aRep)
        }
        return newImage
    }
}
