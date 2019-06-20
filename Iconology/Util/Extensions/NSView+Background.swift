//
//  NSView+Background.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/20/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

extension NSView {
    func setBackground(to color: NSColor) {
        wantsLayer = true
        layer?.backgroundColor = color.cgColor
    }
}
