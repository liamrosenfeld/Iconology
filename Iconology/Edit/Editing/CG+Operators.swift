//
//  CG+Operators.swift
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
    
    static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(
            width: lhs.width / rhs,
            height: lhs.height / rhs
        )
    }
}
