//
//  NSImage+Background.swift
//  Iconology
//
//  Created by Liam on 1/18/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func addBackground(_ color: NSColor) -> NSImage {
        // get the size of the original image
        let imageSize = self.size
        
        // Set graphics state
        let rep = makeRep(at: imageSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // fill the background with selected color
        color.setFill()
        let backgoundRect = NSRect(origin: CGPoint.zero, size: imageSize)
        NSBezierPath.fill(backgoundRect)
        
        // rect of image size positioned inside the border
        var imageRect = CGRect.zero
        imageRect.size = imageSize
        imageRect.origin.x = 0
        imageRect.origin.y = 0
        
        // draw in the original image
        self.draw(in: imageRect as NSRect)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        
        return newImage
    }
}
