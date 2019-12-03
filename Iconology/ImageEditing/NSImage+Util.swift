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
    
    var cgImage: CGImage {
        get {
            var imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            return self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
        }
    }
}
