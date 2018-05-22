//
//  DefaultPresets.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

class DefaultPresets {
    // MARK: - Functions
    func addDefaults() {
        Presets.addPreset(name: "Xcode iOS", sizes: xcodeiOS, usePrefix: false)
        Presets.addPreset(name: "Xcode Mac", sizes: xcodeMac, usePrefix: false)
        Presets.addPreset(name: "Xcode iMessage", sizes: xcodeiMessage, usePrefix: false)
        Presets.addPreset(name: "Xcode Apple Watch", sizes: xcodeWatch, usePrefix: false)
        Presets.addPreset(name: "Test", sizes: xcodeiOS, usePrefix: true)
    }
    
    
    // MARK: - Sizes
    let xcodeiOS = [
        "iPhoneNotification2x": (x: 40, y: 40),
        "iPhoneNotification3x": (x: 60, y: 60),
        
        "iPhoneSettings2x": (x: 58, y: 58),
        "iPhoneSettings3x": (x: 87, y: 87),
        
        "iPhoneSpotlight2x": (x: 80, y: 80),
        "iPhoneSpotlight3x": (x: 120, y: 120),
        
        "iPhoneApp2x": (x: 120, y: 120),
        "iPhoneApp3x": (x: 180, y: 180),
        
        "iPadNotification2x": (x: 40, y: 40),
        "iPadNotification3x": (x: 60, y: 60),
        
        "iPadSettings2x": (x: 58, y: 58),
        "iPadSettings3x": (x: 87, y: 87),
        
        "iPadSpotlight2x": (x: 80, y: 80),
        "iPadSpotlight3x": (x: 120, y: 120),
        
        "iPadApp2x": (x: 120, y: 120),
        "iPadApp3x": (x: 180, y: 180),
        
        "iOSAppStore": (x: 1280, y: 1280)
    ]


    let xcodeMac = [
        "mac16pt1x": (x: 16, y: 16),
        "mac16pt2x": (x: 32, y: 32),
        
        "mac32pt1x": (x: 32, y: 32),
        "mac32pt2x": (x: 64, y: 64),
        
        "mac128pt1x": (x: 128, y: 128),
        "mac128pt2x": (x: 64, y: 64),
        
        "mac256pt1x": (x: 256, y: 256),
        "mac256pt2x": (x: 512, y: 512),
        
        "mac512pt1x": (x: 512, y: 512),
        "mac512pt2x": (x: 1024, y: 1024)
    ]

    let xcodeiMessage = [
        "iMessage-iPhoneMessages2x": (x: 120, y: 90),
        "iMessage-iPhoneMessages3x": (x: 180, y: 135),
        
        "iMessage-iPadMessages2x": (x: 134, y: 100),
        "iMessage-iPadProMessages2x": (x: 148, y: 110),
        
        "iMessage-Messages-27x20-2x": (x: 54, y: 40),
        "iMessage-Messages-27x20-3x": (x: 81, y: 60),
        
        "iMessage-Messages-32x24-2x": (x: 64, y: 48),
        "iMessage-Messages-32x24-3x": (x: 96, y: 72),
        
        "iMessage-AppStore": (x: 1024, y: 768)
    ]
    
    let xcodeWatch = [
        "watchNotification30mm": (x: 48, y: 48),
        "watchNotification42mm": (x: 55, y: 55),
        
        "watchCompanion2x": (x: 58, y: 58),
        "watchCompanion3x": (x: 87, y: 87),
        
        "watchHomeAll": (x: 40, y: 40),
        
        "watchLong42mm": (x: 88, y: 88),
        
        "watchShort38mm": (x: 172, y: 172),
        "watchShort42mm": (x: 196, y: 196),
        
        "watchAppStore": (x: 1024, y: 1024)
    ]
}
