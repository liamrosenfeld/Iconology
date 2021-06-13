//
//  XcodePlatformSizes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct XcodeSize: Hashable, Codable {
    var name: String
    var size: CGSize
    var scale: Int
    var idiom: String
    var platform: String?
    var role: String?
    var subtype: String?

    init(
        name: String,
        w: Double,
        h: Double,
        scale: Int,
        idiom: String,
        platform: String? = nil,
        role: String? = nil,
        subtype: String? = nil
    ) {
        self.name = name
        size = NSSize(width: w, height: h)
        self.scale = scale
        self.idiom = idiom
        self.platform = platform
        self.role = role
        self.subtype = subtype
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(width)
    }
}

enum XcodePlatformSizes {
    static let ios = [
        XcodeSize(name: "iPhoneNotification2x", w: 20, h: 20, scale: 2, idiom: "iphone"),
        XcodeSize(name: "iPhoneNotification3x", w: 20, h: 20, scale: 3, idiom: "iphone"),

        XcodeSize(name: "iPhoneSettings2x", w: 29, h: 29, scale: 2, idiom: "iphone"),
        XcodeSize(name: "iPhoneSettings3x", w: 29, h: 29, scale: 3, idiom: "iphone"),

        XcodeSize(name: "iPhoneSpotlight2x", w: 40, h: 40, scale: 2, idiom: "iphone"),
        XcodeSize(name: "iPhoneSpotlight3x", w: 40, h: 40, scale: 3, idiom: "iphone"),

        XcodeSize(name: "iPhoneApp2x", w: 60, h: 60, scale: 2, idiom: "iphone"),
        XcodeSize(name: "iPhoneApp3x", w: 60, h: 60, scale: 3, idiom: "iphone"),

        XcodeSize(name: "iPadNotification1x", w: 20, h: 20, scale: 1, idiom: "ipad"),
        XcodeSize(name: "iPadNotification2x", w: 20, h: 20, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iPadSettings1x", w: 29, h: 29, scale: 1, idiom: "ipad"),
        XcodeSize(name: "iPadSettings2x", w: 29, h: 29, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iPadSpotlight1x", w: 40, h: 40, scale: 1, idiom: "ipad"),
        XcodeSize(name: "iPadSpotlight2x", w: 40, h: 40, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iPadApp1x", w: 76, h: 76, scale: 1, idiom: "ipad"),
        XcodeSize(name: "iPadApp2x", w: 76, h: 76, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iPadProApp2x", w: 83.5, h: 83.5, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iOSAppStore", w: 1024, h: 1024, scale: 1, idiom: "ios-marketing")
    ]

    static let mac = [
        XcodeSize(name: "mac16pt1x", w: 16, h: 16, scale: 1, idiom: "mac"),
        XcodeSize(name: "mac16pt2x", w: 16, h: 16, scale: 2, idiom: "mac"),

        XcodeSize(name: "mac32pt1x", w: 32, h: 32, scale: 1, idiom: "mac"),
        XcodeSize(name: "mac32pt2x", w: 32, h: 32, scale: 2, idiom: "mac"),

        XcodeSize(name: "mac128pt1x", w: 128, h: 128, scale: 1, idiom: "mac"),
        XcodeSize(name: "mac128pt2x", w: 128, h: 128, scale: 2, idiom: "mac"),

        XcodeSize(name: "mac256pt1x", w: 256, h: 256, scale: 1, idiom: "mac"),
        XcodeSize(name: "mac256pt2x", w: 256, h: 256, scale: 2, idiom: "mac"),

        XcodeSize(name: "mac512pt1x", w: 512, h: 512, scale: 1, idiom: "mac"),
        XcodeSize(name: "mac512pt2x", w: 512, h: 512, scale: 2, idiom: "mac")
    ]

    static let message = [
        XcodeSize(name: "iMessage-iPhoneMessages2x", w: 60, h: 45, scale: 2, idiom: "iphone"),
        XcodeSize(name: "iMessage-iPhoneMessages3x", w: 60, h: 45, scale: 3, idiom: "iphone"),

        XcodeSize(name: "iMessage-iPadMessages2x", w: 67, h: 50, scale: 2, idiom: "ipad"),
        XcodeSize(name: "iMessage-iPadProMessages2x", w: 74, h: 55, scale: 2, idiom: "ipad"),

        XcodeSize(name: "iMessage-Messages-27x20-2x", w: 27, h: 20, scale: 2, idiom: "universal", platform: "ios"),
        XcodeSize(name: "iMessage-Messages-27x20-3x", w: 27, h: 20, scale: 3, idiom: "universal", platform: "ios"),

        XcodeSize(name: "iMessage-Messages-32x24-2x", w: 32, h: 24, scale: 2, idiom: "universal", platform: "ios"),
        XcodeSize(name: "iMessage-Messages-32x24-3x", w: 32, h: 24, scale: 3, idiom: "universal", platform: "ios"),

        XcodeSize(name: "iMessage-AppStore", w: 1024, h: 768, scale: 1, idiom: "ios-marketing", platform: "ios")
    ]

    static let watch = [
        XcodeSize(name: "WatchNotification38", w: 24, h: 24, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "38mm"),
        XcodeSize(name: "watchNotification42", w: 27.5, h: 27.5, scale: 2, idiom: "watch", role: "notificationCenter", subtype: "42mm"),

        XcodeSize(name: "WatchCompanionSettings2x", w: 29, h: 29, scale: 2, idiom: "watch", role: "companionSettings"),
        XcodeSize(name: "WatchCompanionSettings3x", w: 29, h: 29, scale: 3, idiom: "watch", role: "companionSettings"),

        XcodeSize(name: "WatchHome38", w: 40, h: 40, scale: 2, idiom: "watch", role: "appLauncher", subtype: "38mm"),
        XcodeSize(name: "WatchHome40", w: 44, h: 44, scale: 2, idiom: "watch", role: "appLauncher", subtype: "40mm"),
        XcodeSize(name: "WatchHome44", w: 50, h: 50, scale: 2, idiom: "watch", role: "appLauncher", subtype: "44mm"),

        XcodeSize(name: "WatchQuick38", w: 86, h: 86, scale: 2, idiom: "watch", role: "quickLook", subtype: "38mm"),
        XcodeSize(name: "WatchQuick42", w: 98, h: 98, scale: 2, idiom: "watch", role: "quickLook", subtype: "42mm"),
        XcodeSize(name: "WatchQuick44", w: 108, h: 108, scale: 2, idiom: "watch", role: "quickLook", subtype: "44mm"),

        XcodeSize(name: "WatchAppStore", w: 1024, h: 1024, scale: 1, idiom: "watch-marketing")
    ]
}
