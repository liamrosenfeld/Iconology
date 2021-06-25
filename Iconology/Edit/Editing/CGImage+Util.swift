//
//  NSImage+Util.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/22/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    @inline(__always) var cgImage: CGImage {
        var imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
    }
}

extension CGImage {
    @inline(__always) var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    @inline(__always) func makeContext(size: CGSize) -> CGContext {
        return CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: self.bitsPerComponent,
            bytesPerRow: 0,
            space: self.colorSpace!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
    }
}
