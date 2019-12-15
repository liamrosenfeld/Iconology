//
//  NSRect+Center.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/25/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension NSRect {
    var center: NSPoint {
        get {
            var point = origin
            point.x += width / 2
            point.y += height / 2
            return point
        }

        set {
            var point = newValue
            point.x -= width / 2
            point.y -= height / 2
            origin = point
        }
    }
}
