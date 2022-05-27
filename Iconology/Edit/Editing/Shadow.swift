//
//  CGPath+Shadow.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/28/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics

extension CGImage {
    static func makeShadow(path: CGPath, frame: CGSize, attributes: ShadowAttributes) -> CGImage {
        let context = CGContext(
            data: nil,
            width: Int(frame.width),
            height: Int(frame.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
        
        // gets rid of the inside
        // allows it to not add a background to background-less images
        let boundingRect = context.boundingBoxOfClipPath
        context.addRect(boundingRect)
        context.addPath(path)
        context.clip(using: .evenOdd)
        
        // get shadow attributes
        let shadowColor = CGColor(gray: 0, alpha: attributes.opacity / 100)
        let offset = CGSize(width: 0, height: frame.height * -0.01) // -0.01 from macOS icon photoshop template
        let adjustedBlur = (frame.height / 1000) * attributes.blur // make blur consistent between different sizes
        
        // draw shadow
        context.addPath(path)
        context.setShadow(offset: offset, blur: adjustedBlur, color: shadowColor)
        context.setBlendMode(.normal)
        context.fillPath()
        
        return context.makeImage()!
    }
}
