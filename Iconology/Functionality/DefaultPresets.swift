//
//  DefaultPresets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

class DefaultPresets {
    // MARK: - Functions
    func addDefaults() {
        UserPresets.addPreset(name: "Xcode iOS", sizes: xcodeiOS, usePrefix: false)
        UserPresets.addPreset(name: "Xcode Mac", sizes: xcodeMac, usePrefix: false)
        UserPresets.addPreset(name: "Xcode iMessage", sizes: xcodeiMessage, usePrefix: false)
        UserPresets.addPreset(name: "Xcode Apple Watch", sizes: xcodeWatch, usePrefix: false)
        UserPresets.addPreset(name: "QT", sizes: qt, usePrefix: true)
        UserPresets.savePresets()
    }
    
    
    // MARK: - Sizes
    let xcodeiOS = [
        "iPhoneNotification2x": size(x: 40, y: 40),
        "iPhoneNotification3x": size(x: 60, y: 60),
        
        "iPhoneSettings2x": size(x: 58, y: 58),
        "iPhoneSettings3x": size(x: 87, y: 87),
        
        "iPhoneSpotlight2x": size(x: 80, y: 80),
        "iPhoneSpotlight3x": size(x: 120, y: 120),
        
        "iPhoneApp2x": size(x: 120, y: 120),
        "iPhoneApp3x": size(x: 180, y: 180),
        
        "iPadNotification1x": size(x: 20, y: 20),
        "iPadNotification2x": size(x: 40, y: 40),
        
        "iPadSettings1x": size(x: 29, y: 29),
        "iPadSettings2x": size(x: 58, y: 58),
        
        "iPadSpotlight1x": size(x: 40, y: 40),
        "iPadSpotlight2x": size(x: 80, y: 80),
        
        "iPadApp1x": size(x: 76, y: 76),
        "iPadApp2x": size(x: 152, y: 152),
        
        "iPadProApp2x": size(x: 167, y: 167),
        
        "iOSAppStore": size(x: 1024, y: 1024)
    ]
    
    
    let xcodeMac = [
        "mac16pt1x": size(x: 16, y: 16),
        "mac16pt2x": size(x: 32, y: 32),
        
        "mac32pt1x": size(x: 32, y: 32),
        "mac32pt2x": size(x: 64, y: 64),
        
        "mac128pt1x": size(x: 128, y: 128),
        "mac128pt2x": size(x: 64, y: 64),
        
        "mac256pt1x": size(x: 256, y: 256),
        "mac256pt2x": size(x: 512, y: 512),
        
        "mac512pt1x": size(x: 512, y: 512),
        "mac512pt2x": size(x: 1024, y: 1024)
    ]
    
    let xcodeiMessage = [
        "iMessage-iPhoneMessages2x": size(x: 120, y: 90),
        "iMessage-iPhoneMessages3x": size(x: 180, y: 135),
        
        "iMessage-iPadMessages2x": size(x: 134, y: 100),
        "iMessage-iPadProMessages2x": size(x: 148, y: 110),
        
        "iMessage-Messages-27x20-2x": size(x: 54, y: 40),
        "iMessage-Messages-27x20-3x": size(x: 81, y: 60),
        
        "iMessage-Messages-32x24-2x": size(x: 64, y: 48),
        "iMessage-Messages-32x24-3x": size(x: 96, y: 72),
        
        "iMessage-AppStore": size(x: 1024, y: 768)
    ]
    
    let xcodeWatch = [
        "watchNotification30mm": size(x: 48, y: 48),
        "watchNotification42mm": size(x: 55, y: 55),
        
        "watchCompanion2x": size(x: 58, y: 58),
        "watchCompanion3x": size(x: 87, y: 87),
        
        "watchHomeAll": size(x: 40, y: 40),
        
        "watchLong42mm": size(x: 88, y: 88),
        
        "watchShort38mm": size(x: 172, y: 172),
        "watchShort42mm": size(x: 196, y: 196),
        
        "watchAppStore": size(x: 1024, y: 1024)
    ]
    
    let qt = [
        "16": size(x: 16, y: 16),
        "24": size(x: 24, y: 24),
        "32": size(x: 32, y: 32),
        "48": size(x: 48, y: 48),
        "64": size(x: 64, y: 64),
        "96": size(x: 96, y: 96),
        "128": size(x: 128, y: 128),
        "512": size(x: 512, y: 512),
        "1024": size(x: 1024, y: 1024),
        "2048": size(x: 2048, y: 2048)
    ]
}
