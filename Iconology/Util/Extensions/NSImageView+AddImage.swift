//
//  NSImageView+AddImage.swift
//  Iconology
//
//  Created by Liam on 12/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImageView {
    func resize(to image: NSImage) {
        // Get Image Size
        let imageSize = image.size
        let w: CGFloat = imageSize.width
        let h: CGFloat = imageSize.height
        
        let max: CGFloat = 500
        
        // Get Mod Image Size
        var size = NSSize(width: 0, height: 0)
        if w > h {
            if w > max {
                size.width = max
                size.height = max * (h / w)
            } else {
                size.width = w
                size.height = h
            }
        } else if w < h {
            if h > max {
                size.width = max * (w / h)
                size.height = max
            } else {
                size.width = w
                size.height = h
            }
        } else {
            if w > max || h > max {
                size.width = 350
                size.height = 350
            } else {
                size.width = w
                size.height = h
            }
        }
        
        // Get Origin
        let x = 510 - (size.width / 2)
        let y = 380 - (size.height / 2)
        let origin = NSPoint(x: x, y: y)
        
        // Resize
        let rect = NSRect(origin: origin, size: size)
        self.frame = rect
    }
    
    func addImage(_ image: NSImage) {
        let size = self.frame.size
        let image = image.resize(to: size)
        self.image = image
    }
}
