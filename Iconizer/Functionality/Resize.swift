//
//  Resize.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 2/3/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func resize(name: String, image: NSImage, w: Int, h: Int, saveTo: URL) {
    let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    let newImage = NSImage(size: destSize)
    newImage.lockFocus()
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
    newImage.unlockFocus()
    newImage.size = destSize
    
    let imageData = newImage.tiffRepresentation! as NSData
    save(to: saveTo, name: name, data: imageData)
}

func save(to: URL, name: String, data: NSData) {
    let filename = to.appendingPathComponent("\(name).png")
    try? data.write(to: filename)
}
