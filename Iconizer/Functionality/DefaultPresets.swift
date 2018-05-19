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
        Presets.addPreset(name: "Xcode iOS", sizes: xcodeiOS)
        Presets.addPreset(name: "Xcode Mac", sizes: xcodeMac)
        Presets.addPreset(name: "Xcode iMessage", sizes: xcodeiMessage)
    }
    
    
    // MARK: - Sizes
    let xcodeiOS = [
        "iPhoneNotification2x": [40, 40],
        "iPhoneNotification3x": [60, 60],
        
        "iPhoneSettings2x": [58, 58],
        "iPhoneSettings3x": [87, 87],
        
        "iPhoneSpotlight2x": [80, 80],
        "iPhoneSpotlight3x": [120, 120],
        
        "iPhoneApp2x": [120, 120],
        "iPhoneApp3x": [180, 180],
        
        "iPadNotification2x": [40, 40],
        "iPadNotification3x": [60, 60],
        
        "iPadSettings2x": [58, 58],
        "iPadSettings3x": [87, 87],
        
        "iPadSpotlight2x": [80, 80],
        "iPadSpotlight3x": [120, 120],
        
        "iPadApp2x": [120, 120],
        "iPadApp3x": [180, 180],
        
        "iOSAppStore": [1280, 1280]
    ]


    let xcodeMac = [
        "mac16pt1x": [16, 16],
        "mac16pt2x": [32, 32],
        
        "mac32pt1x": [32, 32],
        "mac32pt2x": [64, 64],
        
        "mac128pt1x": [128, 128],
        "mac128pt2x": [64, 64],
        
        "mac256pt1x": [256, 256],
        "mac256pt2x": [512, 512],
        
        "mac512pt1x": [512, 512],
        "mac512pt2x": [1024, 1024]
    ]

    let xcodeiMessage = [
        "iMessage-iPhoneMessages2x": [120, 90],
        "iMessage-iPhoneMessages3x": [180, 135],
        
        "iMessage-iPadMessages2x": [134, 100],
        "iMessage-iPadProMessages2x": [148, 110],
        
        "iMessage-Messages-27x20-2x": [54, 40],
        "iMessage-Messages-27x20-3x": [81, 60],
        
        "iMessage-Messages-32x24-2x": [64, 48],
        "iMessage-Messages-32x24-3x": [96, 72],
        
        "iMessage-AppStore": [1024, 768]
    ]
    
    let xcodeWatch = [
        "watchNotification30mm": [48, 48],
        "watchNotification42mm": [55, 55],
        
        "watchCompanion2x": [58, 58],
        "watchCompanion3x": [87, 87],
        
        "watchHomeAll": [40, 40],
        
        "watchLong42mm": [88, 88],
        
        "watchShort38mm": [172, 172],
        "watchShort42mm": [196, 196],
        
        "watchAppStore": [1024, 1024]
    ]
}
