//
//  resize.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/3/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

// Called in OptionViewController
func xcode9_iPhone (image: NSImage){
    var AppStore: NSImage?
    
    let iPhoneNotification2x = resize(image: image, w: 40, h: 40)
    let iPhoneNotification3x = resize(image: image, w: 60, h: 60)
    
    let iPhoneSettings2x = resize(image: image, w: 58, h: 58)
    let iPhoneSettings3x = resize(image: image, w: 87, h: 87)
    
    let iPhoneSpotlight2x = resize(image: image, w: 80, h: 80)
    let iPhoneSpotlight3x = resize(image: image, w: 120, h: 120)
    
    let iPhoneApp2x = resize(image: image, w: 120, h: 120)
    let iPhoneApp3x = resize(image: image, w: 180, h: 180)
    
    AppStore = resize(image: image, w: 1280, h: 1280)
}

func xcode9_iPad (image: NSImage){
    var AppStore: NSImage?
    
    let iPadNotification2x = resize(image: image, w: 40, h: 40)
    let iPadNotification3x = resize(image: image, w: 60, h: 60)
    
    let iPadSettings2x = resize(image: image, w: 58, h: 58)
    let iPadSettings3x = resize(image: image, w: 87, h: 87)
    
    let iPadSpotlight2x = resize(image: image, w: 80, h: 80)
    let iPadSpotlight3x = resize(image: image, w: 120, h: 120)
    
    let iPadApp2x = resize(image: image, w: 120, h: 120)
    let iPadApp3x = resize(image: image, w: 180, h: 180)
    
    if AppStore != nil {
        AppStore = resize(image: image, w: 1280, h: 1280)
    }
}

func xcode9_mac (image: NSImage){
    let mac16pt1x = resize(image: image, w: 16, h: 16)
    let mac16pt2x = resize(image: image, w: 32, h: 32)
    
    let mac32pt1x = resize(image: image, w: 32, h: 32)
    let mac32pt2x = resize(image: image, w: 64, h: 64)
    
    let mac128pt1x = resize(image: image, w: 128, h: 128)
    let mac128pt2x = resize(image: image, w: 64, h: 64)
    
    let mac256pt1x = resize(image: image, w: 256, h: 256)
    let mac256pt2x = resize(image: image, w: 512, h: 512)
    
    let mac512pt1x = resize(image: image, w: 512, h: 512)
    let mac512pt2x = resize(image: image, w: 1024, h: 1024)
}

func xcode8_iPhone (image: NSImage){
    let iPhoneNotification2x = resize(image: image, w: 40, h: 40)
    let iPhoneNotification3x = resize(image: image, w: 60, h: 60)
    
    let iPhoneSettings2x = resize(image: image, w: 58, h: 58)
    let iPhoneSettings3x = resize(image: image, w: 87, h: 87)
    
    let iPhoneSpotlight2x = resize(image: image, w: 80, h: 80)
    let iPhoneSpotlight3x = resize(image: image, w: 120, h: 120)
    
    let iPhoneApp2x = resize(image: image, w: 120, h: 120)
    let iPhoneApp3x = resize(image: image, w: 180, h: 180)
}

func xcode8_iPad (image: NSImage){
    let iPadNotification2x = resize(image: image, w: 40, h: 40)
    let iPadNotification3x = resize(image: image, w: 60, h: 60)
    
    let iPadSettings2x = resize(image: image, w: 58, h: 58)
    let iPadSettings3x = resize(image: image, w: 87, h: 87)
    
    let iPadSpotlight2x = resize(image: image, w: 80, h: 80)
    let iPadSpotlight3x = resize(image: image, w: 120, h: 120)
    
    let iPadApp2x = resize(image: image, w: 120, h: 120)
    let iPadApp3x = resize(image: image, w: 180, h: 180)
    let iPadProApp2x = resize(image: image, w: 167, h: 167)
}

func xcode8_mac (image: NSImage){
    let mac16pt1x = resize(image: image, w: 16, h: 16)
    let mac16pt2x = resize(image: image, w: 32, h: 32)
    
    let mac32pt1x = resize(image: image, w: 32, h: 32)
    let mac32pt2x = resize(image: image, w: 64, h: 64)
    
    let mac128pt1x = resize(image: image, w: 128, h: 128)
    let mac128pt2x = resize(image: image, w: 64, h: 64)
    
    let mac256pt1x = resize(image: image, w: 256, h: 256)
    let mac256pt2x = resize(image: image, w: 512, h: 512)
    
    let mac512pt1x = resize(image: image, w: 512, h: 512)
    let mac512pt2x = resize(image: image, w: 1024, h: 1024)
}


// Actual Resizing Code
func resize(image: NSImage, w: Int, h: Int) -> NSImage {
    let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    let newImage = NSImage(size: destSize)
    newImage.lockFocus()
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
    newImage.unlockFocus()
    newImage.size = destSize
    return NSImage(data: newImage.tiffRepresentation!)!
}
