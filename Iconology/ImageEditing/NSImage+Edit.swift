//
//  NSImage+Edit.swift
//  Iconology
//
//  Created by Liam on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func findFrame(aspect: NSSize) -> NSSize {
        let w = aspect.width
        let h = aspect.height
        let x = self.size.width
        let y = self.size.height
        
        var fullSize = self.size
        if w > h {
            let outerX = x * (w / h)
            let outerY = y
            fullSize = NSSize(width: outerX, height: outerY)
        } else if w < h {
            let outerX = x
            let outerY = y * (h / w)
            fullSize = NSSize(width: outerX, height: outerY)
        } else {
            if x > y {
                let outerX = x
                let outerY = x
                fullSize = NSSize(width: outerX, height: outerY)
            } else if x < y {
                let outerX = y
                let outerY = y
                fullSize = NSSize(width: outerX, height: outerY)
            }
        }
        return fullSize
    }
    
    func scale(by scale: CGFloat) -> NSImage {
        // calc size
        var size = self.size
        size.width  *= scale
        size.height *= scale
        
        // draw the scaled image
        return self.resize(to: size)
    }
    
    func placeInFrame(_ frame: NSSize, at loc: CGPoint) -> NSImage {
        // Make Rep
        let rep = makeRep(at: frame)
        
        // Set Graphics State
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // create rect of ascpect size
        var imageRect = NSRect.zero
        imageRect.size = self.size
        
        // draw the image
        let rect = imageRect
        let x = ((frame.width / 2) - (self.size.width / 2)) + (loc.x * (frame.width / 100))
        let y = ((frame.height / 2) - (self.size.height / 2)) + (loc.y * (frame.height / 100))
        let point = NSPoint(x: x, y: y)
        self.draw(at: point, from: rect, operation: .overlay, fraction: 1)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: self.size)
        newImage.addRepresentation(rep)
        newImage.size = frame
        return newImage
    }
    
    func addBackground(of color: NSColor) -> NSImage {
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
        var imageRect = NSRect.zero
        imageRect.size = imageSize
        imageRect.origin.x = 0
        imageRect.origin.y = 0
        
        // draw in the original image
        self.draw(in: imageRect)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        
        return newImage
    }
    
    func round(by percent: CGFloat) -> NSImage {
        // Make Rep
        let imageSize = self.size
        let rep = makeRep(at: imageSize)
        
        // Set Graphics State
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // create circle size
        let sqrtTwo = CGFloat(sqrt(2.0))
        let wSide = imageSize.width * sqrtTwo - (percent / 100 * (imageSize.width * sqrtTwo - imageSize.width))
        let hSide = imageSize.height * sqrtTwo - (percent / 100 * (imageSize.height * sqrtTwo - imageSize.height))
        let outerSize = CGSize(width: wSide, height: hSide)
        
        // create cicle path
        let adjCenter = CGPoint(x: 0 - (wSide - imageSize.width) / 2, y: 0 - (hSide - imageSize.height) / 2)
        let circleRect = CGRect(origin: adjCenter, size: outerSize)
        let circle = CGPath(ellipseIn: circleRect, transform: nil)
        
        // draw the image in circle
        NSGraphicsContext.current?.cgContext.addPath(circle)
        NSGraphicsContext.current?.cgContext.clip()
        draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        return newImage
    }
    
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
