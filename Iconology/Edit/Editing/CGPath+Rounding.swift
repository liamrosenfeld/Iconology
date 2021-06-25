//
//  CGPath+Rounding.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/23/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics

extension CGPath {
    static func roundedRect(rect: CGRect, roundingPercent: CGFloat) -> CGPath {
        let widthCornerRad = cornerRadius(sideLength: rect.width, percent: roundingPercent)
        let heightCornerRad = cornerRadius(sideLength: rect.height, percent: roundingPercent)
        return CGPath(
            roundedRect: rect,
            cornerWidth: widthCornerRad,
            cornerHeight: heightCornerRad,
            transform: nil
        )
    }
    
    private static func cornerRadius(sideLength: CGFloat, percent: CGFloat) -> CGFloat {
        // Scale the percentage so 0 is square and 1 is circle
        //
        // circle is when corner radius equals half of side length
        // (sqrt2)(s/2)(Pmax) = s/2
        // => Pmax = 1/sqrt2
        let sqrtTwo = CGFloat(2).squareRoot()
        let adjustedPercent = (percent / 100) * (1 / sqrtTwo)
        
        // Diagonal of a quarter of the shape
        // TODO: might cause issues on non square aspect ratios
        let diagonal = sqrtTwo * (sideLength / 2)
        
        // Radius is the diagonal times the adjusted percent
        return adjustedPercent * diagonal
    }
}
