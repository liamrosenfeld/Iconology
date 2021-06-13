//
//  NSImage+Util.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func makeRep(at size: NSSize) -> NSBitmapImageRep {
        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )
        return rep!
    }

    func findFrame(aspect: NSSize) -> NSSize {
        let aspectVal = aspect.width / aspect.height
        let imgAspect = size.width / size.height
        let imgW = size.width
        let imgH = size.height

        if aspect.width == aspect.height {
            let side = max(imgW, imgH)
            return NSSize(width: side, height: side)
        } else if imgAspect > aspectVal {
            let newW = imgW
            let newH = imgW * (aspect.height / aspect.width)
            return NSSize(width: newW, height: newH)
        } else {
            let newW = imgH * aspectVal
            let newH = imgH
            return NSSize(width: newW, height: newH)
        }
    }

    var cgImage: CGImage {
        var imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
    }
}
