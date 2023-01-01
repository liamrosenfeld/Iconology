//
//  DefaultPresets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

let includedPresets = [
    PresetGroup(name: "Xcode", presets: [
        XcodePreset(
            name: "iOS Icon",
            sizes: XcodeIconSizes.ios,
            folderName: "AppIcon.appiconset",
            aspect: .unit,
            enabledModifications: .limitedXcode
        ),
        XcodePreset(
            name: "MacOS Icon",
            sizes: XcodeIconSizes.mac,
            folderName: "AppIcon.appiconset",
            aspect: .unit,
            enabledModifications: .all
        ),
        XcodePreset(
            name: "iMessage Icon",
            sizes: XcodeIconSizes.message,
            folderName: "Messages Icon.stickersiconset",
            aspect: .init(width: 4, height: 3),
            enabledModifications: .limitedXcode
        ),
        XcodePreset(
            name: "Watch Icon",
            sizes: XcodeIconSizes.watch,
            folderName: "AppIcon.appiconset",
            aspect: .unit,
            enabledModifications: .limitedXcode
        )
    ]),
    PresetGroup(name: "Files", presets: [
        PngPreset(),
        IcnsPreset(),
        IcoPreset(name: "Windows ico", sizes: IcoGenerator.winIcoSet),
        IcoPreset(name: "Favicon ico", sizes: IcoGenerator.faviconIcoSet)
    ]),
    PresetGroup(name: "Sets", presets: [
        ImgSetPreset(
            name: "Mac Iconset",
            sizes: ImgSetSizes.macIconset,
            aspect: .unit,
            enabledModifications: .all
        ),
        ImgSetPreset(
            name: "Favicon PNGs",
            sizes: ImgSetSizes.faviconSet,
            aspect: .unit,
            enabledModifications: .all
        )
    ])
]

struct PresetGroup {
    var name: String
    var presets: [any Preset]
}
