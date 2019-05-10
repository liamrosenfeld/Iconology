//
//  NSImage+Round.swift
//  Iconology
//
//  Created by Liam on 1/21/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension NSImage {
    func round(percent: CGFloat) -> NSImage {
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
}
