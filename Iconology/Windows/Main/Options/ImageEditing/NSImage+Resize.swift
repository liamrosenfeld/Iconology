//
//  NSImage+Resize.swift
//  Iconology
//
//  Created by Liam on 12/24/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func resize(to destSize: NSSize) -> NSImage {
        // Set Graphics State
        let rep = makeRep(at: destSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // Place Image in Rep
        let destRect = NSRect(origin: CGPoint.zero, size: destSize)
        self.draw(in: destRect, from: NSRect.zero, operation: NSCompositingOperation.copy, fraction: 1.0)
        
        // Return rep as Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: destSize)
        newImage.addRepresentation(rep)
        newImage.size = destSize
        
        return newImage
    }
}
