//
//  DefaultPresets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

let defaultPresets = [
    PresetGroup(name: "Xcode", presets: [
        Preset(
            name: "iOS",
            type: .xcodeAsset(sizes: XcodePlatformSizes.ios, folderName: "AppIcon.appiconset"),
            useModifications: .limitedXcode()
        ),
        Preset(
            name: "MacOS",
            type: .xcodeAsset(sizes: XcodePlatformSizes.mac, folderName: "AppIcon.appiconset"),
            useModifications: .all()
        ),
        Preset(
            name: "iMessage",
            type: .xcodeAsset(sizes: XcodePlatformSizes.message, folderName: "Messages Icon.stickersiconset"),
            aspect: NSSize(width: 4, height: 3),
            useModifications: .limitedXcode()
        ),
        Preset(
            name: "Watch",
            type: .xcodeAsset(sizes: XcodePlatformSizes.watch, folderName: "AppIcon.appiconset"),
            useModifications: .limitedXcode()
        )
    ]),
    PresetGroup(name: "Files", presets: [
        Preset(name: "png", type: .png, useModifications: .all()),
        Preset(name: "icns", type: .icns, useModifications: .all()),
        Preset(name: "Windows ico", type: .ico(IcoGenerator.winIcoSet), useModifications: .all()),
        Preset(name: "Favicon ico", type: .ico(IcoGenerator.faviconIcoSet), useModifications: .all())
    ]),
    PresetGroup(name: "Sets", presets: [
        Preset(name: "Iconset", type: .imgSet(ImgSetSizes.macIconset), useModifications: .all()),
        Preset(name: "Favicon PNGs", type: .imgSet(ImgSetSizes.faviconSet), useModifications: .all())
    ])
]

struct PresetGroup {
    var name: String
    var presets: [Preset]
}
