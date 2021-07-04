//
//  CGSize+Math.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/30/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics

extension CGSize {
    /// get the points where a line that is an angle offset a vertical line intersects the bounding rectangle
    func intersections(ofAngleOffVertical angle: CGFloat) -> (top: CGPoint, bottom: CGPoint) {
        let absAngle = abs(angle)
        if absAngle < 45 {
            let angleRadians = angle * (.pi / 180)
            let tangent = tan(angleRadians)
            return (
                CGPoint(x: (width / 2) * (1 + tangent), y: height),
                CGPoint(x: (width / 2) * (1 - tangent), y: 0)
            )
        } else if absAngle > 45 {
            let complimentAngleRads = (90 - absAngle) * (.pi / 180)
            let tangent = tan(complimentAngleRads)
            return (
                CGPoint(
                    x: angle > 0 ? width : 0,
                    y: (height / 2) * (1 + tangent)
                ),
                CGPoint(
                    x: angle < 0 ? width : 0,
                    y: (height / 2) * (1 - tangent)
                )
            )
        } else {
            return (
                CGPoint(x: angle > 0 ? width : 0, y: height),
                CGPoint(x: angle < 0 ? width : 0, y: 0)
            )
        }
    }
    
    /// find the smallest possible size that would fit self with a given aspect ratio
    func findFrame(aspect: CGSize) -> CGSize {
        let aspectVal = aspect.width / aspect.height
        let currentAspect = width / height
        
        if aspect.width == aspect.height {
            let side = max(width, height)
            return CGSize(width: side, height: side)
        } else if currentAspect > aspectVal {
            return CGSize(
                width: width,
                height: height * (aspect.height / aspect.width)
            )
        } else {
            return CGSize(
                width: height * aspectVal,
                height: height
            )
        }
    }
}
