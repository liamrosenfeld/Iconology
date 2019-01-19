//
//  NSImage+Shift.swift
//  Iconology
//
//  Created by Liam on 1/18/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func shift(x: CGFloat, y: CGFloat) -> NSImage {
        // get the size of the original image
        let imageSize = self.size
        
        // Set graphics state
        let rep = makeRep(at: imageSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // Percent to Pixel Value
        let transformTrueX = x * (imageSize.width / 100)
        let transformTrueY = y * (imageSize.height / 100)
        
        // rect of old image size positioned inside the border
        var imageRect = CGRect.zero
        imageRect.size = imageSize
        imageRect.origin.x = transformTrueX
        imageRect.origin.y = transformTrueY
        
        // draw in the original image
        self.draw(in: imageRect as NSRect)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        
        return newImage
    }
}
