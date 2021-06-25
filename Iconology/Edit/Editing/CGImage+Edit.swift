//
//  CGImage+Edit.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/22/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit
import CoreGraphics

extension CGImage {
    func resized(to destSize: CGSize, quality: CGInterpolationQuality) -> CGImage {
        let context = makeContext(size: destSize)
        context.interpolationQuality = quality
        context.draw(self, in: CGRect(origin: .zero, size: destSize))
        
        return context.makeImage()!
    }
    
    func scaled(by percent: CGFloat, quality: CGInterpolationQuality) -> CGImage {
        // calc size
        let scale = percent / 100
        let size = CGSize(
            width: CGFloat(width) * scale,
            height: CGFloat(height) * scale
        )
        
        // draw the scaled image
        return resized(to: size, quality: quality)
    }
    
    func placedInFrame(frame: CGSize, shift: CGPoint, background: CGColor?, mask: CGPath?) -> CGImage {
        let context = makeContext(size: frame)
        
        // mask
        if let mask = mask {
            context.addPath(mask)
            context.clip()
        }
        
        // fill the background with selected color
        if let background = background {
            context.setFillColor(background)
            context.fill(CGRect(origin: .zero, size: frame))
        }
        
        // place image
        let imageRect = CGRect(origin: shift, size: self.size)
        context.draw(self, in: imageRect)
        
        return context.makeImage()!
    }
    
    func masked(to path: CGPath) -> CGImage {
        // make context
        let context = makeContext(size: self.size)
        
        // mask
        context.addPath(path)
        context.clip()
        
        // add image
        let imageRect = CGRect(origin: .zero, size: self.size)
        context.draw(self, in: imageRect)
        
        return context.makeImage()!
    }
}

