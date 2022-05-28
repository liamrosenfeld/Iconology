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
        if self.size == destSize { return self }
        
        let context = CGImage.makeContext(size: destSize, colorSpace: self.colorSpace!)
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
    
    func placedInFrame(frame: CGSize, imageOrigin: CGPoint, background: Background, mask: CGPath?) -> CGImage {
        let context = CGImage.makeContext(size: frame, colorSpace: self.colorSpace!)
        
        // add a mask to the context
        if let mask = mask {
            context.addPath(mask)
            context.clip()
        }
        
        // draw the selected background
        switch background {
        case .none:
            break
        case .color(let color):
            context.setFillColor(color)
            context.fill(CGRect(origin: .zero, size: frame))
        case .gradient(let gradient):
            let (startPoint, endPoint) = frame.intersections(ofAngleOffVertical: gradient.angle)
            context.drawLinearGradient(gradient.cgGradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        }
        
        // place image
        let imageRect = CGRect(origin: imageOrigin, size: self.size)
        context.draw(self, in: imageRect)
        
        return context.makeImage()!
    }
    
    func overlayed(_ topImage: CGImage) -> CGImage {
        let context = CGImage.makeContext(size: self.size, colorSpace: self.colorSpace!)
        let imageRect = CGRect(origin: .zero, size: self.size)
        context.draw(self, in: imageRect)
        context.draw(topImage, in: imageRect)
        return context.makeImage()!
    }
}
