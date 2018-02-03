//
//  resize.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/3/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

// Called in OptionViewController
func ios11_iPhone (imageURL: NSURL){
    
}

func ios11_iPad (imageURL: NSURL){
    
}

func ios10_iPhone (imageURL: NSURL){
    
}

func ios10_iPad (imageURL: NSURL){
    
}

func ios9_iPhone (imageURL: NSURL){
    
}

func ios9_iPad (imageURL: NSURL){
    
}


// Actual Resizing Code
func resize(image: NSImage, w: Int, h: Int) -> NSImage {
    var destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    var newImage = NSImage(size: destSize)
    newImage.lockFocus()
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
    newImage.unlockFocus()
    newImage.size = destSize
    return NSImage(data: newImage.tiffRepresentation!)!
}
