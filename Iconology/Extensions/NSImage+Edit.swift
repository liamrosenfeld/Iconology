//
//  NSImage+Edit.swift
//  Iconology
//
//  Created by Liam on 12/24/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func resize(w: Int, h: Int) -> NSImage {
        // Set Graphics State
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let rep = makeRep(at: destSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // Place Image in Rep
        let destRect = NSRect(origin: CGPoint(x: 0, y: 0), size: destSize)
        self.draw(in: destRect, from: NSZeroRect, operation: NSCompositingOperation.copy, fraction: 1.0)
        
        // Return rep as Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: destSize)
        newImage.addRepresentation(rep)

        return newImage
    }
    
    func addBackground(_ color: NSColor) -> NSImage {
        // get the size of the original image
        let inputBitmap = NSBitmapImageRep(data: self.tiffRepresentation!)!
        let imageSize = NSSize(width: inputBitmap.pixelsWide, height: inputBitmap.pixelsHigh)
        
        // Set graphics state
        let rep = makeRep(at: imageSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // fill the background with selected color
        color.setFill()
        let backgoundRect = NSMakeRect(0, 0, imageSize.width, imageSize.height)
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
    
    func shift(x: CGFloat, y: CGFloat) -> NSImage {
        // get the size of the original image
        let inputBitmap = NSBitmapImageRep(data: self.tiffRepresentation!)!
        let imageSize = NSSize(width: inputBitmap.pixelsWide, height: inputBitmap.pixelsHigh)
        
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
    
    func scale(_ ratio: CGFloat) -> NSImage {
        // get the size of the original image
        let inputBitmap = NSBitmapImageRep(data: self.tiffRepresentation!)!
        let imageSize = NSSize(width: inputBitmap.pixelsWide, height: inputBitmap.pixelsHigh)
        
        // Set graphics state
        let rep = makeRep(at: imageSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // create rect of scaled image size
        var imageRect = CGRect.zero
        imageRect.size.width = imageSize.width * ratio
        imageRect.size.height = imageSize.height * ratio
        imageRect.origin.x = 0
        imageRect.origin.y = 0
        
        // draw the scaled image
        let scaledimage = self.resize(w: Int(self.size.width * ratio), h: Int(self.size.height * ratio))
        let rect = imageRect as NSRect
        let ptX: Double = (Double(imageSize.width) - Double(imageRect.size.width)) / 2
        let ptY: Double = (Double(imageSize.height) - Double(imageRect.size.height)) / 2
        let point = NSPoint(x: ptX, y: ptY)
        scaledimage.draw(at: point, from: rect, operation: .overlay, fraction: 1)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        
        return newImage
    }
    
    func applyAspect(w: Int, h: Int) -> NSImage {
        // get the size of the original image
        let inputBitmap = NSBitmapImageRep(data: self.tiffRepresentation!)!
        let w = Double(w)
        let h = Double(h)
        let x = Double(inputBitmap.pixelsWide)
        let y = Double(inputBitmap.pixelsHigh)
        let imageSize = NSSize(width: x, height: y)
        
        if (x / y) == (w / h) {
            return self
        }
        
        // Get Size of Outer Rect
        var fullSize = imageSize
        if w > h {
            let outerX: Double = x * (w / h)
            let outerY: Double = y
            fullSize = NSSize(width: outerX, height: outerY)
        } else if w < h {
            let outerX: Double = x
            let outerY: Double = y * (h / w)
            fullSize = NSSize(width: outerX, height: outerY)
        } else {
            if x > y {
                let outerX: Double = x
                let outerY: Double = x
                fullSize = NSSize(width: outerX, height: outerY)
            } else if x < y {
                let outerX: Double = y
                let outerY: Double = y
                fullSize = NSSize(width: outerX, height: outerY)
            } else {
                return self
            }
        }
        
        // Set graphics state
        let rep = makeRep(at: fullSize)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // create rect of image size
        var imageRect = CGRect.zero
        imageRect.size = imageSize
        imageRect.origin.x = 0
        imageRect.origin.y = 0
        
        // draw the image
        let rect = imageRect as NSRect
        let ptX: Double = (Double(fullSize.width) - Double(imageRect.size.width)) / 2
        let ptY: Double = (Double(fullSize.height) - Double(imageRect.size.height)) / 2
        let point = NSPoint(x: ptX, y: ptY)
        self.draw(at: point, from: rect, operation: .overlay, fraction: 1)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        return newImage
    }
    
    fileprivate func makeRep(at size: NSSize) -> NSBitmapImageRep {
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                pixelsWide: Int(size.width),
                                pixelsHigh: Int(size.height),
                                bitsPerSample: 8,
                                samplesPerPixel: 4,
                                hasAlpha: true,
                                isPlanar: false,
                                colorSpaceName: .calibratedRGB,
                                bytesPerRow: 0,
                                bitsPerPixel: 0)
        return rep!
    }
}
