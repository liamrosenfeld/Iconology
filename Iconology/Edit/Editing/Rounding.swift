//
//  CGPath+Rounding.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/23/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics

extension CGPath {
    static func circularRoundedRect(rect: CGRect, roundingPercent: CGFloat) -> CGPath {
        let widthCornerRad = cornerRadius(sideLength: rect.width, percent: roundingPercent)
        let heightCornerRad = cornerRadius(sideLength: rect.height, percent: roundingPercent)
        return CGPath(
            roundedRect: rect,
            cornerWidth: widthCornerRad,
            cornerHeight: heightCornerRad,
            transform: nil
        )
    }
    
    static func continuousRoundedRect(rect: CGRect, roundingPercent: CGFloat) -> CGPath {
        // get corner radius from percent
        let widthCornerRad = cornerRadius(sideLength: rect.width, percent: roundingPercent)
        let heightCornerRad = cornerRadius(sideLength: rect.height, percent: roundingPercent)
        let cornerRadius = max(widthCornerRad, heightCornerRad)
        
        // helper functions
        func topLeft(x: CGFloat, y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.origin.x + (x * cornerRadius),
                y: rect.origin.y + (y * cornerRadius)
            )
        }
        func topRight(x: CGFloat, y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.origin.x + rect.size.width - (x * cornerRadius),
                y: rect.origin.y + (y * cornerRadius)
            )
        }
        func btmRight(x: CGFloat, y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.origin.x + rect.size.width - (x * cornerRadius),
                y: rect.origin.y + rect.size.height - (y * cornerRadius)
            )
        }
        func btmLeft(x: CGFloat, y: CGFloat) -> CGPoint {
            CGPoint(
                x: rect.origin.x + (x * cornerRadius),
                y: rect.origin.y + rect.size.height - (y * cornerRadius)
            )
        }
        
        // add to curve
        // this code was generated based on UIBezierPath(roundedRect:, cornerRadius:)
        // a writeup for how this works can be found here:
        // https://liamrosenfeld.com/apple_icon_quest
        let path = CGMutablePath()
        path.move(to: topLeft(x: 1.528665, y: 0.0))
        path.addLine(to: topRight(x: 1.528665, y: 0.0))
        path.addCurve(
            to: topRight(x: 0.63149379, y: 0.07491139),
            control1: topRight(x: 1.08849296, y: 0.0),
            control2: topRight(x: 0.86840694, y: 0.0)
        )
        path.addLine(to: topRight(x: 0.63149379, y: 0.07491139))
        path.addCurve(
            to: topRight(x: 0.07491139, y: 0.63149379),
            control1: topRight(x: 0.37282383, y: 0.16905956),
            control2: topRight(x: 0.16905956, y: 0.37282383)
        )
        path.addCurve(
            to: topRight(x: 0.0, y: 1.52866498),
            control1: topRight(x: 0.0, y: 0.86840694),
            control2: topRight(x: 0.0, y: 1.08849296)
        )
        path.addLine(to: btmRight(x: 0.0, y: 1.528665))
        path.addCurve(
            to: btmRight(x: 0.07491139, y: 0.63149379),
            control1: btmRight(x: 0.0, y: 1.08849296),
            control2: btmRight(x: 0.0, y: 0.86840694)
        )
        path.addLine(to: btmRight(x: 0.07491139, y: 0.63149379))
        path.addCurve(
            to: btmRight(x: 0.63149379, y: 0.07491139),
            control1: btmRight(x: 0.16905956, y: 0.37282383),
            control2: btmRight(x: 0.37282383, y: 0.16905956)
        )
        path.addCurve(
            to: btmRight(x: 1.52866498, y: 0.0),
            control1: btmRight(x: 0.86840694, y: 0.0),
            control2: btmRight(x: 1.08849296, y: 0.0)
        )
        path.addLine(to: btmLeft(x: 1.528665, y: 0.0))
        path.addCurve(
            to: btmLeft(x: 0.63149379, y: 0.07491139),
            control1: btmLeft(x: 1.08849296, y: 0.0),
            control2: btmLeft(x: 0.86840694, y: 0.0)
        )
        path.addLine(to: btmLeft(x: 0.63149379, y: 0.07491139))
        path.addCurve(
            to: btmLeft(x: 0.07491139, y: 0.63149379),
            control1: btmLeft(x: 0.37282383, y: 0.16905956),
            control2: btmLeft(x: 0.16905956, y: 0.37282383)
        )
        path.addCurve(
            to: btmLeft(x: 0.0, y: 1.52866498),
            control1: btmLeft(x: 0.0, y: 0.86840694),
            control2: btmLeft(x: 0.0, y: 1.08849296)
        )
        path.addLine(to: topLeft(x: 0.0, y: 1.528665))
        path.addCurve(
            to: topLeft(x: 0.07491139, y: 0.63149379),
            control1: topLeft(x: 0.0, y: 1.08849296),
            control2: topLeft(x: 0.0, y: 0.86840694)
        )
        path.addLine(to: topLeft(x: 0.07491139, y: 0.63149379))
        path.addCurve(
            to: topLeft(x: 0.63149379, y: 0.07491139),
            control1: topLeft(x: 0.16905956, y: 0.37282383),
            control2: topLeft(x: 0.37282383, y: 0.16905956)
        )
        path.addCurve(
            to: topLeft(x: 1.52866498, y: 0.0),
            control1: topLeft(x: 0.86840694, y: 0.0),
            control2: topLeft(x: 1.08849296, y: 0.0)
        )
        path.closeSubpath()
        return path
    }

    static func squircle(rect: CGRect, roundingPercent: CGFloat) -> CGPath {
        // get squircle parameters from function parameters
        let n = nFromPercent(roundingPercent)
        let halfWidth = rect.width / 2
        let halfHeight = rect.height / 2
        
        // generate path using polar equation
        let path = CGMutablePath()
        path.move(to: squircleEq(n: n, theta: 0, halfWidth: halfWidth, halfHeight: halfHeight) + rect.origin)
        for theta in stride(from: 0.0, to: .pi * 2, by: .pi / 300) {
            path.addLine(to: squircleEq(n: n, theta: theta, halfWidth: halfWidth, halfHeight: halfHeight) + rect.origin)
        }
        path.closeSubpath()
        return path
    }
    
    private static func nFromPercent(_ percent: CGFloat) -> Double {
        /*
         Checkpoints for scaling:
         ┏   0% -> Rectangle (n=∞) -- Skipped from applying before this
         ┣  ~0% -> Almost Rectangle (n=20)
         ┣  50% -> True Squircle (n=4)
         ┗ 100% -> Circle (n=2)
         */
        let almostRectangle = 20.0
        let trueSquircle = 4.0
        let circle = 2.0
        
        if percent <= 50 {
            // range: [almost rectangle, true squircle]
            let percentDelta: Double = percent * 2.0
            let delta = (almostRectangle - trueSquircle) * (percentDelta / 100)
            return almostRectangle - delta
        } else {
            // range: (true squircle, circle]
            let percentDelta: Double = (percent - 50.0) * 2.0
            let delta = (trueSquircle - circle) * (percentDelta / 100)
            return trueSquircle - delta
        }
    }
    
    private static func squircleEq(n: Double, theta: Double, halfWidth: Double, halfHeight: Double) -> CGPoint {
        let thetaMod = theta.truncatingRemainder(dividingBy: .pi * 2)
        let cosSign: Double = {
            if thetaMod < .pi / 2 {
                return 1
            } else if thetaMod < .pi * (3/2) {
                return -1
            } else {
                return 1
            }
        }()
        let sinSign: Double = thetaMod < .pi ? 1 : -1
        let x = pow(abs(cos(theta)), 2/n) * halfWidth * cosSign + halfWidth
        let y = pow(abs(sin(theta)), 2/n) * halfHeight * sinSign + halfHeight
        return CGPoint(x: x, y: y)
    }
    
    private static func cornerRadius(sideLength: CGFloat, percent: CGFloat) -> CGFloat {
        // Scale the percentage so 0 is square and 1 is circle
        // circle is when corner radius equals half of side length
        // everything else is a percentage of the two
        // TODO: need to check on not square aspect ratios
        return (sideLength * percent) / 200
    }
}
