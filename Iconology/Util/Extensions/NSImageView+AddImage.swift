//
//  NSImageView+AddImage.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit
import func AVFoundation.AVMakeRect

extension NSImageView {
    func resize(to image: NSImage) {
        // Get Image Size
        let imageSize = image.size
        let w: CGFloat = imageSize.width
        let h: CGFloat = imageSize.height

        let maxSize = CGSize(width: 500, height: 500)

        // Fit within 500x500 if needed
        var size = NSSize(width: 0, height: 0)
        if w <= 500 && h <= 500 {
            size = image.size
        } else {
            size = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: maxSize)).size
        }

        // Get Origin
        let x = 510 - (size.width / 2)
        let y = 380 - (size.height / 2)
        let origin = NSPoint(x: x, y: y)

        // Resize
        let rect = NSRect(origin: origin, size: size)
        frame = rect
    }

    func addImage(_ image: NSImage) {
        let size = frame.size
        let image = image.resize(to: size)
        self.image = image
    }
}
