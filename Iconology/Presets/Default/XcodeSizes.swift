//
//  XcodeSizes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct XcodeSizes {
    static func createPresets() -> [XcodePreset] {
        var presets = [XcodePreset]()
        presets.append(XcodePreset(name: "iOS", sizes: iosSizes, folderName: "AppIcon.appiconset"))
        presets.append(XcodePreset(name: "MacOS", sizes: macSizes, folderName: "AppIcon.appiconset"))
        presets.append(XcodePreset(name: "iMessage", sizes: messageSizes, folderName: "Messages Icon.stickersiconset", aspect: Aspect(w: 4, h: 3)))
        presets.append(XcodePreset(name: "Watch", sizes: watchSizes, folderName: "AppIcon.appiconset"))
        return presets
    }
    
    private static let iosSizes = [
        XcodePreset.XcodeSizes(name: "iPhoneNotification2x", x: 20, y: 20, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneNotification3x", x: 20, y: 20, scale: 3, idiom: "iphone"),
        
        XcodePreset.XcodeSizes(name: "iPhoneSettings2x", x: 29, y: 29, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneSettings3x", x: 29, y: 29, scale: 3, idiom: "iphone"),
        
        XcodePreset.XcodeSizes(name: "iPhoneSpotlight2x", x: 40, y: 40, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneSpotlight3x", x: 40, y: 40, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPhoneApp2x", x: 60, y: 60, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneApp3x", x: 60, y: 60, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPadNotification1x", x: 20, y: 20, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadNotification2x", x: 20, y: 20, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadSettings1x", x: 29, y: 29, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadSettings2x", x: 29, y: 29, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadSpotlight1x", x: 40, y: 40, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadSpotlight2x", x: 40, y: 40, scale: 2, idiom: "ipad"),
    
        XcodePreset.XcodeSizes(name: "iPadApp1x", x: 76, y: 76, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadApp2x", x: 76, y: 76, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadProApp2x", x: 83.5, y: 83.5, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iOSAppStore", x: 1024, y: 1024, scale: 1, idiom: "ios-marketing")
    ]
    
    
    private static let macSizes = [
        XcodePreset.XcodeSizes(name: "mac16pt1x", x: 16, y: 16, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac16pt2x", x: 16, y: 16, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac32pt1x", x: 32, y: 32, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac32pt2x", x: 32, y: 32, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac128pt1x", x: 128, y: 128, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac128pt2x", x: 128, y: 128, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac256pt1x", x: 256, y: 256, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac256pt2x", x: 256, y: 256, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac512pt1x", x: 512, y: 512, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac512pt2x", x: 512, y: 512, scale: 2, idiom: "mac")
    ]
    
    private static let messageSizes = [
        XcodePreset.XcodeSizes(name: "iMessage-iPhoneMessages2x", x: 60, y: 45, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iMessage-iPhoneMessages3x", x: 60, y: 45, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iMessage-iPadMessages2x", x: 67, y: 50, scale: 2, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iMessage-iPadProMessages2x", x: 74, y: 55, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iMessage-Messages-27x20-2x", x: 27, y: 20, scale: 2, idiom: "universal", platform: "ios"),
        XcodePreset.XcodeSizes(name: "iMessage-Messages-27x20-3x", x: 27, y: 20, scale: 3, idiom: "universal", platform: "ios"),

        XcodePreset.XcodeSizes(name: "iMessage-Messages-32x24-2x", x: 32, y: 24, scale: 2, idiom: "universal", platform: "ios"),
        XcodePreset.XcodeSizes(name: "iMessage-Messages-32x24-3x", x: 32, y: 24, scale: 3, idiom: "universal", platform: "ios"),

        XcodePreset.XcodeSizes(name: "iMessage-AppStore", x: 1024, y: 768, scale: 1, idiom: "ios-marketing", platform: "ios")
    ]
    
    private static let watchSizes = [
        XcodePreset.XcodeSizes(name: "WatchNotification38", x: 24, y: 24, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "watchNotification42", x: 27.5, y: 27.5, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "42mm"),
        
        XcodePreset.XcodeSizes(name: "WatchCompanionSettings2x", x: 29, y: 29, scale: 2, idiom: "watch", role: "companionSettings"),
        XcodePreset.XcodeSizes(name: "WatchCompanionSettings3x", x: 29, y: 29, scale: 3, idiom: "watch", role: "companionSettings"),
        
        XcodePreset.XcodeSizes(name: "WatchHome38", x: 40, y: 40, scale: 2, idiom: "watch", role: "appLauncher", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "WatchHome40", x: 44, y: 44, scale: 2, idiom: "watch", role: "appLauncher", subtype: "40mm"),
        XcodePreset.XcodeSizes(name: "WatchHome44", x: 50, y: 50, scale: 2, idiom: "watch", role: "appLauncher", subtype: "44mm"),
        
        XcodePreset.XcodeSizes(name: "WatchQuick38", x: 86, y: 86, scale: 2, idiom: "watch", role: "quickLook", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "WatchQuick42", x: 98, y: 98, scale: 2, idiom: "watch", role: "quickLook", subtype: "42mm"),
        XcodePreset.XcodeSizes(name: "WatchQuick44", x: 108, y: 108, scale: 2, idiom: "watch", role: "quickLook", subtype: "44mm"),
        
        XcodePreset.XcodeSizes(name: "WatchAppStore", x: 1024, y: 1024, scale: 1, idiom: "watch-marketing"),
    ]
}
