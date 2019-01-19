//
//  Image+Scale.swift
//  Iconology
//
//  Created by Liam on 1/18/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func scale(aspect: NSSize, scale: CGFloat) -> NSImage {
        // Make Rep
        let imageSize = self.size
        let aspectSize = findAspectSize(aspectSize: aspect, imageSize: imageSize)
        let rep = makeRep(at: aspectSize)
        
        // Resize Image
        let resizedImage = self.scale(to: scale)
        let resizedSize = resizedImage.size
        
        // Set Graphics State
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        // create rect of ascpect size
        var imageRect = CGRect.zero
        imageRect.size = resizedSize
        imageRect.origin.x = 0
        imageRect.origin.y = 0
        
        // draw the image
        let rect = imageRect as NSRect
        let x = (aspectSize.width / 2) - (resizedSize.width / 2)
        let y = (aspectSize.height / 2) - (resizedSize.height / 2)
        let point = NSPoint(x: x, y: y)
        resizedImage.draw(at: point, from: rect, operation: .overlay, fraction: 1)
        
        // Convert To Image
        NSGraphicsContext.restoreGraphicsState()
        let newImage = NSImage(size: imageSize)
        newImage.addRepresentation(rep)
        return newImage
    }
    
    private func scale(to scale: CGFloat) -> NSImage {
        // get the size of the original image
        let imageSize = self.size
        
        // Set graphics state
        let w = imageSize.width * scale
        let h = imageSize.height * scale
        let destSize = NSSize(width: w, height: h)
        
        // draw the scaled image
        let scaledImage = self.resize(to: destSize)
        return scaledImage
    }
    
    private func findAspectSize(aspectSize: NSSize, imageSize: NSSize) -> NSSize {
        let w = aspectSize.width
        let h = aspectSize.height
        let x = imageSize.width
        let y = imageSize.height
        
        var fullSize = imageSize
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
    
    private func makeRep(at size: NSSize) -> NSBitmapImageRep {
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
