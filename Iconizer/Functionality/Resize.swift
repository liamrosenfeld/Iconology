//
//  Resize.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 2/3/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

var directory: URL?

// MARK: - Sizes
// Xcode 9
func xcode9_iOS (image: NSImage, url: URL) {
    directory = url
        
    resize(name: "iPhoneNotification2x", image: image, w: 40, h: 40)
    resize(name: "iPhoneNotification3x", image: image, w: 60, h: 60)
    
    resize(name: "iPhoneSettings2x", image: image, w: 58, h: 58)
    resize(name: "iPhoneSettings3x", image: image, w: 87, h: 87)
    
    resize(name: "iPhoneSpotlight2x", image: image, w: 80, h: 80)
    resize(name: "iPhoneSpotlight3x", image: image, w: 120, h: 120)
    
    resize(name: "iPhoneApp2x", image: image, w: 120, h: 120)
    resize(name: "iPhoneApp3x", image: image, w: 180, h: 180)
    
    resize(name: "iPadNotification2x", image: image, w: 40, h: 40)
    resize(name: "iPadNotification3x", image: image, w: 60, h: 60)
    
    resize(name: "iPadSettings2x", image: image, w: 58, h: 58)
    resize(name: "iPadSettings3x", image: image, w: 87, h: 87)
    
    resize(name: "iPadSpotlight2x", image: image, w: 80, h: 80)
    resize(name: "iPadSpotlight3x", image: image, w: 120, h: 120)
    
    resize(name: "iPadApp2x", image: image, w: 120, h: 120)
    resize(name: "iPadApp3x", image: image, w: 180, h: 180)
    
    resize(name: "iOSAppStore", image: image, w: 1280, h: 1280)
}

func xcode9_mac (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "mac16pt1x", image: image, w: 16, h: 16)
    resize(name: "mac16pt2x", image: image, w: 32, h: 32)
    
    resize(name: "mac32pt1x", image: image, w: 32, h: 32)
    resize(name: "mac32pt2x", image: image, w: 64, h: 64)
    
    resize(name: "mac128pt1x", image: image, w: 128, h: 128)
    resize(name: "mac128pt2x", image: image, w: 64, h: 64)
    
    resize(name: "mac256pt1x", image: image, w: 256, h: 256)
    resize(name: "mac256pt2x", image: image, w: 512, h: 512)
    
    resize(name: "mac512pt1x", image: image, w: 512, h: 512)
    resize(name: "mac512pt2x", image: image, w: 1024, h: 1024)
}

func xcode9_iMessage (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "iMessage-iPhoneMessages2x", image: image, w: 120, h: 90)
    resize(name: "iMessage-iPhoneMessages3x", image: image, w: 180, h: 135)
    
    resize(name: "iMessage-iPadMessages2x", image: image, w: 134, h: 100)
    resize(name: "iMessage-iPadProMessages2x", image: image, w: 148, h: 110)
    
    resize(name: "iMessage-Messages-27x20-2x", image: image, w: 54, h: 40)
    resize(name: "iMessage-Messages-27x20-3x", image: image, w: 81, h: 60)
    
    resize(name: "iMessage-Messages-32x24-2x", image: image, w: 64, h: 48)
    resize(name: "iMessage-Messages-32x24-3x", image: image, w: 96, h: 72)
    
    resize(name: "iMessage-AppStore", image: image, w: 1024, h: 768)
    
}


func xcode9_watch (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "watchNotification30mm", image: image, w: 48, h: 48)
    resize(name: "watchNotification42mm", image: image, w: 55, h: 55)
    
    resize(name: "watchCompanion2x", image: image, w: 58, h: 58)
    resize(name: "watchCompanion3x", image: image, w: 87, h: 87)
    
    resize(name: "watchHomeAll", image: image, w: 40, h: 40)
    
    resize(name: "watchLong42mm", image: image, w: 88, h: 88)
    
    resize(name: "watchShort38mm", image: image, w: 172, h: 172)
    resize(name: "watchShort42mm", image: image, w: 196, h: 196)
    
    resize(name: "watchAppStore", image: image, w: 1024, h: 1024)
}

// Xcode 8
func xcode8_iOS (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "iPhoneNotification2x", image: image, w: 40, h: 40)
    resize(name: "iPhoneNotification3x", image: image, w: 60, h: 60)
    
    resize(name: "iPhoneSettings2x", image: image, w: 58, h: 58)
    resize(name: "iPhoneSettings3x", image: image, w: 87, h: 87)
    
    resize(name: "iPhoneSpotlight2x", image: image, w: 80, h: 80)
    resize(name: "iPhoneSpotlight3x", image: image, w: 120, h: 120)
    
    resize(name: "iPhoneApp2x", image: image, w: 120, h: 120)
    resize(name: "iPhoneApp3x", image: image, w: 180, h: 180)
    
    resize(name: "iPadNotification2x", image: image, w: 40, h: 40)
    resize(name: "iPadNotification3x", image: image, w: 60, h: 60)
    
    resize(name: "iPadSettings2x", image: image, w: 58, h: 58)
    resize(name: "iPadSettings3x", image: image, w: 87, h: 87)
    
    resize(name: "iPadSpotlight2x", image: image, w: 80, h: 80)
    resize(name: "iPadSpotlight3x", image: image, w: 120, h: 120)
    
    resize(name: "iPadApp2x", image: image, w: 120, h: 120)
    resize(name: "iPadApp3x", image: image, w: 180, h: 180)
    resize(name: "iPadProApp2x", image: image, w: 167, h: 167)
    
}

func xcode8_mac (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "mac16pt1x", image: image, w: 16, h: 16)
    resize(name: "mac16pt2x", image: image, w: 32, h: 32)
    
    resize(name: "mac32pt1x", image: image, w: 32, h: 32)
    resize(name: "mac32pt2x", image: image, w: 64, h: 64)
    
    resize(name: "mac128pt1x", image: image, w: 128, h: 128)
    resize(name: "mac128pt2x", image: image, w: 64, h: 64)
    
    resize(name: "mac256pt1x", image: image, w: 256, h: 256)
    resize(name: "mac256pt2x", image: image, w: 512, h: 512)
    
    resize(name: "mac512pt1x", image: image, w: 512, h: 512)
    resize(name: "mac512pt2x", image: image, w: 1024, h: 1024)
}

func xcode8_iMessage (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "iMessage-iPhoneMessages2x", image: image, w: 120, h: 90)
    resize(name: "iMessage-iPhoneMessages3x", image: image, w: 180, h: 135)
    
    resize(name: "iMessage-iPadMessages2x", image: image, w: 134, h: 100)
    resize(name: "iMessage-iPadProMessages2x", image: image, w: 148, h: 110)
    
    resize(name: "iMessage-Messages-27x20-2x", image: image, w: 54, h: 40)
    resize(name: "iMessage-Messages-27x20-3x", image: image, w: 81, h: 60)
    
    resize(name: "iMessage-Messages-32x24-2x", image: image, w: 64, h: 48)
    resize(name: "iMessage-Messages-32x24-3x", image: image, w: 96, h: 72)
    
    resize(name: "iMessage-AppStore", image: image, w: 1024, h: 768)
    
}

func xcode8_watch (image: NSImage, url: URL) {
    directory = url
    
    resize(name: "watchNotification30mm", image: image, w: 48, h: 48)
    resize(name: "watchNotification42mm", image: image, w: 55, h: 55)
    
    resize(name: "watchCompanion2x", image: image, w: 58, h: 58)
    resize(name: "watchCompanion3x", image: image, w: 87, h: 87)
    
    resize(name: "watchHomeAll", image: image, w: 40, h: 40)
    
    resize(name: "watchLong42mm", image: image, w: 88, h: 88)
    
    resize(name: "watchShort38mm", image: image, w: 172, h: 172)
    resize(name: "watchShort42mm", image: image, w: 196, h: 196)
}

// MARK: - Resize and Save
func resize(name: String, image: NSImage, w: Int, h: Int) {
    let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
    let newImage = NSImage(size: destSize)
    newImage.lockFocus()
    image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
    newImage.unlockFocus()
    newImage.size = destSize
    
    let imageData = newImage.tiffRepresentation! as NSData
    save(name: name, data: imageData, directory: directory!)
}

func save(name: String, data: NSData, directory: URL) {
    let filename = directory.appendingPathComponent("\(name).png")
    try? data.write(to: filename)
}
