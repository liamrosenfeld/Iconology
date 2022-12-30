//
//  CGSize+Math.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/30/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics

extension CGSize {
    /// Finds the points where a line (offset clockwise from a vertical line) intersects the bounding rectangle.
    /// Range: [0, 360]
    func intersections(ofAngleOffVertical angle: CGFloat) -> (top: CGPoint, bottom: CGPoint) {
        if angle < 45 || (angle >= 315 && angle <= 360) {
            // lands on the top
            let angleRadians = angle * (.pi / 180)
            let tangent = tan(angleRadians)
            return (
                CGPoint(x: (width / 2) * (1 + tangent), y: height),
                CGPoint(x: (width / 2) * (1 - tangent), y: 0)
            )
        } else if angle < 135 {
            // lands on the right
            let complimentAngleRads = (90 - angle) * (.pi / 180)
            let tangent = tan(complimentAngleRads)
            return (
                CGPoint(x: width, y: (height / 2) * (1 + tangent)),
                CGPoint(x: 0, y: (height / 2) * (1 - tangent))
            )
        } else if angle < 225 {
            // lands on the bottom
            let angleRadians = angle * (.pi / 180)
            let tangent = tan(angleRadians)
            return (
                CGPoint(x: (width / 2) * (1 - tangent), y: 0),
                CGPoint(x: (width / 2) * (1 + tangent), y: height)
            )
        } else if angle < 315 {
            // lands on the left
            let complimentAngleRads = (270 - angle) * (.pi / 180)
            let tangent = tan(complimentAngleRads)
            return (
                CGPoint(x: 0, y: (height / 2) * (1 - tangent)),
                CGPoint(x: width, y: (height / 2) * (1 + tangent))
            )
        }
        else {
            // out of range
            preconditionFailure("angle out of range")
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
