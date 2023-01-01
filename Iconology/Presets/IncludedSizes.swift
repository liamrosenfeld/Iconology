//
//  IncludedSizes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

enum XcodeIconSizes {
    static let ios = [
        XcodeIconSize(name: "iPhoneNotification2x", w: 20, h: 20, scale: 2, idiom: "iphone"),
        XcodeIconSize(name: "iPhoneNotification3x", w: 20, h: 20, scale: 3, idiom: "iphone"),

        XcodeIconSize(name: "iPhoneSettings2x", w: 29, h: 29, scale: 2, idiom: "iphone"),
        XcodeIconSize(name: "iPhoneSettings3x", w: 29, h: 29, scale: 3, idiom: "iphone"),

        XcodeIconSize(name: "iPhoneSpotlight2x", w: 40, h: 40, scale: 2, idiom: "iphone"),
        XcodeIconSize(name: "iPhoneSpotlight3x", w: 40, h: 40, scale: 3, idiom: "iphone"),

        XcodeIconSize(name: "iPhoneApp2x", w: 60, h: 60, scale: 2, idiom: "iphone"),
        XcodeIconSize(name: "iPhoneApp3x", w: 60, h: 60, scale: 3, idiom: "iphone"),

        XcodeIconSize(name: "iPadNotification1x", w: 20, h: 20, scale: 1, idiom: "ipad"),
        XcodeIconSize(name: "iPadNotification2x", w: 20, h: 20, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iPadSettings1x", w: 29, h: 29, scale: 1, idiom: "ipad"),
        XcodeIconSize(name: "iPadSettings2x", w: 29, h: 29, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iPadSpotlight1x", w: 40, h: 40, scale: 1, idiom: "ipad"),
        XcodeIconSize(name: "iPadSpotlight2x", w: 40, h: 40, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iPadApp1x", w: 76, h: 76, scale: 1, idiom: "ipad"),
        XcodeIconSize(name: "iPadApp2x", w: 76, h: 76, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iPadProApp2x", w: 83.5, h: 83.5, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iOSAppStore", w: 1024, h: 1024, scale: 1, idiom: "ios-marketing")
    ]

    static let mac = [
        XcodeIconSize(name: "mac16pt1x", w: 16, h: 16, scale: 1, idiom: "mac"),
        XcodeIconSize(name: "mac16pt2x", w: 16, h: 16, scale: 2, idiom: "mac"),

        XcodeIconSize(name: "mac32pt1x", w: 32, h: 32, scale: 1, idiom: "mac"),
        XcodeIconSize(name: "mac32pt2x", w: 32, h: 32, scale: 2, idiom: "mac"),

        XcodeIconSize(name: "mac128pt1x", w: 128, h: 128, scale: 1, idiom: "mac"),
        XcodeIconSize(name: "mac128pt2x", w: 128, h: 128, scale: 2, idiom: "mac"),

        XcodeIconSize(name: "mac256pt1x", w: 256, h: 256, scale: 1, idiom: "mac"),
        XcodeIconSize(name: "mac256pt2x", w: 256, h: 256, scale: 2, idiom: "mac"),

        XcodeIconSize(name: "mac512pt1x", w: 512, h: 512, scale: 1, idiom: "mac"),
        XcodeIconSize(name: "mac512pt2x", w: 512, h: 512, scale: 2, idiom: "mac")
    ]

    static let message = [
        XcodeIconSize(name: "iMessage-iPhoneMessages2x", w: 60, h: 45, scale: 2, idiom: "iphone"),
        XcodeIconSize(name: "iMessage-iPhoneMessages3x", w: 60, h: 45, scale: 3, idiom: "iphone"),

        XcodeIconSize(name: "iMessage-iPadMessages2x", w: 67, h: 50, scale: 2, idiom: "ipad"),
        XcodeIconSize(name: "iMessage-iPadProMessages2x", w: 74, h: 55, scale: 2, idiom: "ipad"),

        XcodeIconSize(name: "iMessage-Messages-27x20-2x", w: 27, h: 20, scale: 2, idiom: "universal", platform: "ios"),
        XcodeIconSize(name: "iMessage-Messages-27x20-3x", w: 27, h: 20, scale: 3, idiom: "universal", platform: "ios"),

        XcodeIconSize(name: "iMessage-Messages-32x24-2x", w: 32, h: 24, scale: 2, idiom: "universal", platform: "ios"),
        XcodeIconSize(name: "iMessage-Messages-32x24-3x", w: 32, h: 24, scale: 3, idiom: "universal", platform: "ios"),

        XcodeIconSize(name: "iMessage-AppStore", w: 1024, h: 768, scale: 1, idiom: "ios-marketing", platform: "ios")
    ]

    static let watch = [
        XcodeIconSize(name: "WatchNotification38", w: 24, h: 24, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "38mm"),
        XcodeIconSize(name: "watchNotification42", w: 27.5, h: 27.5, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "42mm"),

        XcodeIconSize(name: "WatchCompanionSettings2x", w: 29, h: 29, scale: 2, idiom: "watch", role: "companionSettings"),
        XcodeIconSize(name: "WatchCompanionSettings3x", w: 29, h: 29, scale: 3, idiom: "watch", role: "companionSettings"),

        XcodeIconSize(name: "WatchHome38", w: 40, h: 40, scale: 2, idiom: "watch", role: "appLauncher", subtype: "38mm"),
        XcodeIconSize(name: "WatchHome40", w: 44, h: 44, scale: 2, idiom: "watch", role: "appLauncher", subtype: "40mm"),
        XcodeIconSize(name: "WatchHome44", w: 50, h: 50, scale: 2, idiom: "watch", role: "appLauncher", subtype: "44mm"),

        XcodeIconSize(name: "WatchQuick38", w: 86, h: 86, scale: 2, idiom: "watch", role: "quickLook", subtype: "38mm"),
        XcodeIconSize(name: "WatchQuick42", w: 98, h: 98, scale: 2, idiom: "watch", role: "quickLook", subtype: "42mm"),
        XcodeIconSize(name: "WatchQuick44", w: 108, h: 108, scale: 2, idiom: "watch", role: "quickLook", subtype: "44mm"),

        XcodeIconSize(name: "WatchAppStore", w: 1024, h: 1024, scale: 1, idiom: "watch-marketing")
    ]
}

enum ImgSetSizes {
    // https://developer.apple.com/library/archive/documentation/GraphicsAnimation/Conceptual/HighResolutionOSX/Optimizing/Optimizing.html
    static let macIconset = [
        ImgSetSize(name: "icon_16x16", w: 16, h: 16),
        ImgSetSize(name: "icon_16x16@2x", w: 32, h: 32),
        ImgSetSize(name: "icon_32x32", w: 32, h: 32),
        ImgSetSize(name: "icon_32x32@2x", w: 64, h: 64),
        ImgSetSize(name: "icon_128x128", w: 128, h: 128),
        ImgSetSize(name: "icon_128x128@2x", w: 256, h: 256),
        ImgSetSize(name: "icon_256x256", w: 256, h: 256),
        ImgSetSize(name: "icon_256x256@2x", w: 512, h: 512),
        ImgSetSize(name: "icon_512x512", w: 512, h: 512),
        ImgSetSize(name: "icon_512x512@2x", w: 1024, h: 1024)
    ]

    // https://github.com/audreyr/favicon-cheat-sheet
    static let faviconSet = [
        ImgSetSize(name: "favicon-16", w: 16, h: 16),
        ImgSetSize(name: "favicon-32", w: 32, h: 32),
        ImgSetSize(name: "favicon-57", w: 57, h: 57),
        ImgSetSize(name: "favicon-76", w: 76, h: 76),
        ImgSetSize(name: "favicon-96", w: 96, h: 96),
        ImgSetSize(name: "favicon-120", w: 120, h: 120),
        ImgSetSize(name: "favicon-128", w: 128, h: 128),
        ImgSetSize(name: "favicon-144", w: 144, h: 144),
        ImgSetSize(name: "favicon-152", w: 152, h: 152),
        ImgSetSize(name: "favicon-180", w: 180, h: 180),
        ImgSetSize(name: "favicon-195", w: 195, h: 195),
        ImgSetSize(name: "favicon-196", w: 196, h: 196),
        ImgSetSize(name: "favicon-228", w: 228, h: 228)
    ]
}

