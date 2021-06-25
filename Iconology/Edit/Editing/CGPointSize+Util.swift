//
//  CGPoint:Size+Util.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/23/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(
            x: lhs.x + rhs.x,
            y: lhs.y + rhs.y
        )
    }
}

extension CGSize {
    func findFrame(aspect: CGSize) -> CGSize {
        let aspectVal = aspect.width / aspect.height
        let currentAspect = width / height
        
        if aspect.width == aspect.height {
            let side = max(width, height)
            return NSSize(width: side, height: side)
        } else if currentAspect > aspectVal {
            return NSSize(
                width: width,
                height: height * (aspect.height / aspect.width)
            )
        } else {
            return NSSize(
                width: height * aspectVal,
                height: height
            )
        }
    }
    
    static func -(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(
            width: lhs.width - rhs.width,
            height: lhs.height - rhs.height
        )
    }
    
    static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(
            width: lhs.width * rhs,
            height: lhs.height * rhs
        )
    }
}
