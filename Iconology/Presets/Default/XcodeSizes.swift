//
//  XcodeSizes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

//swiftlint:disable line_length
struct XcodeSizes {
    static func createPresets() -> [XcodePreset] {
        var presets = [XcodePreset]()
        presets.append(XcodePreset(name: "iOS", sizes: iosSizes, folderName: "AppIcon.appiconset", round: false))
        presets.append(XcodePreset(name: "MacOS", sizes: macSizes, folderName: "AppIcon.appiconset", round: true))
        presets.append(XcodePreset(name: "iMessage", sizes: messageSizes, folderName: "Messages Icon.stickersiconset", aspect: NSSize(width: 4, height: 3), round: false))
        presets.append(XcodePreset(name: "Watch", sizes: watchSizes, folderName: "AppIcon.appiconset", round: true))
        return presets
    }

    private static let iosSizes = [
        XcodePreset.XcodeSizes(name: "iPhoneNotification2x", w: 20, h: 20, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneNotification3x", w: 20, h: 20, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPhoneSettings2x", w: 29, h: 29, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneSettings3x", w: 29, h: 29, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPhoneSpotlight2x", w: 40, h: 40, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneSpotlight3x", w: 40, h: 40, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPhoneApp2x", w: 60, h: 60, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iPhoneApp3x", w: 60, h: 60, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iPadNotification1x", w: 20, h: 20, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadNotification2x", w: 20, h: 20, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadSettings1x", w: 29, h: 29, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadSettings2x", w: 29, h: 29, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadSpotlight1x", w: 40, h: 40, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadSpotlight2x", w: 40, h: 40, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadApp1x", w: 76, h: 76, scale: 1, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iPadApp2x", w: 76, h: 76, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iPadProApp2x", w: 83.5, h: 83.5, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iOSAppStore", w: 1024, h: 1024, scale: 1, idiom: "ios-marketing")
    ]

    private static let macSizes = [
        XcodePreset.XcodeSizes(name: "mac16pt1x", w: 16, h: 16, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac16pt2x", w: 16, h: 16, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac32pt1x", w: 32, h: 32, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac32pt2x", w: 32, h: 32, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac128pt1x", w: 128, h: 128, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac128pt2x", w: 128, h: 128, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac256pt1x", w: 256, h: 256, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac256pt2x", w: 256, h: 256, scale: 2, idiom: "mac"),

        XcodePreset.XcodeSizes(name: "mac512pt1x", w: 512, h: 512, scale: 1, idiom: "mac"),
        XcodePreset.XcodeSizes(name: "mac512pt2x", w: 512, h: 512, scale: 2, idiom: "mac")
    ]

    private static let messageSizes = [
        XcodePreset.XcodeSizes(name: "iMessage-iPhoneMessages2x", w: 60, h: 45, scale: 2, idiom: "iphone"),
        XcodePreset.XcodeSizes(name: "iMessage-iPhoneMessages3x", w: 60, h: 45, scale: 3, idiom: "iphone"),

        XcodePreset.XcodeSizes(name: "iMessage-iPadMessages2x", w: 67, h: 50, scale: 2, idiom: "ipad"),
        XcodePreset.XcodeSizes(name: "iMessage-iPadProMessages2x", w: 74, h: 55, scale: 2, idiom: "ipad"),

        XcodePreset.XcodeSizes(name: "iMessage-Messages-27x20-2x", w: 27, h: 20, scale: 2, idiom: "universal", platform: "ios"),
        XcodePreset.XcodeSizes(name: "iMessage-Messages-27x20-3x", w: 27, h: 20, scale: 3, idiom: "universal", platform: "ios"),

        XcodePreset.XcodeSizes(name: "iMessage-Messages-32x24-2x", w: 32, h: 24, scale: 2, idiom: "universal", platform: "ios"),
        XcodePreset.XcodeSizes(name: "iMessage-Messages-32x24-3x", w: 32, h: 24, scale: 3, idiom: "universal", platform: "ios"),

        XcodePreset.XcodeSizes(name: "iMessage-AppStore", w: 1024, h: 768, scale: 1, idiom: "ios-marketing", platform: "ios")
    ]

    private static let watchSizes = [
        XcodePreset.XcodeSizes(name: "WatchNotification38", w: 24, h: 24, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "watchNotification42", w: 27.5, h: 27.5, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "42mm"),

        XcodePreset.XcodeSizes(name: "WatchCompanionSettings2x", w: 29, h: 29, scale: 2, idiom: "watch", role: "companionSettings"),
        XcodePreset.XcodeSizes(name: "WatchCompanionSettings3x", w: 29, h: 29, scale: 3, idiom: "watch", role: "companionSettings"),

        XcodePreset.XcodeSizes(name: "WatchHome38", w: 40, h: 40, scale: 2, idiom: "watch", role: "appLauncher", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "WatchHome40", w: 44, h: 44, scale: 2, idiom: "watch", role: "appLauncher", subtype: "40mm"),
        XcodePreset.XcodeSizes(name: "WatchHome44", w: 50, h: 50, scale: 2, idiom: "watch", role: "appLauncher", subtype: "44mm"),

        XcodePreset.XcodeSizes(name: "WatchQuick38", w: 86, h: 86, scale: 2, idiom: "watch", role: "quickLook", subtype: "38mm"),
        XcodePreset.XcodeSizes(name: "WatchQuick42", w: 98, h: 98, scale: 2, idiom: "watch", role: "quickLook", subtype: "42mm"),
        XcodePreset.XcodeSizes(name: "WatchQuick44", w: 108, h: 108, scale: 2, idiom: "watch", role: "quickLook", subtype: "44mm"),

        XcodePreset.XcodeSizes(name: "WatchAppStore", w: 1024, h: 1024, scale: 1, idiom: "watch-marketing")
    ]
}
