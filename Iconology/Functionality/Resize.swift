//
//  Resize.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/3/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func resize(name: String, image: NSImage, w: Int, h: Int, saveTo: URL) {
    let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(destSize.width), pixelsHigh: Int(destSize.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)
    rep?.size = destSize
    NSGraphicsContext.saveGraphicsState()
    if let aRep = rep {
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: aRep)
    }
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
    NSGraphicsContext.restoreGraphicsState()
    let newImage = NSImage(size: destSize)
    if let aRep = rep {
        newImage.addRepresentation(aRep)
    }
    save(to: saveTo, name: name, image: newImage)
}
