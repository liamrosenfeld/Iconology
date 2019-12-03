//
//  DefaultPresets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct DefaultPresets {
    var presets = [PresetGroup]()
    
    init() {
        fill()
    }
    
    mutating func fill() {
        presets.removeAll()
        if Storage.preferences.useXcode {
            let xcode = PresetGroup(title: "Xcode", presets: XcodeSizes.createPresets())
            presets.append(xcode)
        }
        
        if Storage.preferences.useFiles {
            var filePresets = [FilePreset]()
            filePresets.append(FilePreset(name: "png", filetype: .png, prefix: false))
            filePresets.append(FilePreset(name: "icns", filetype: .icns, prefix: false))
            filePresets.append(FilePreset(name: "ico", filetype: .ico(winIconset), prefix: false))
            presets.append(PresetGroup(title: "Files", presets: filePresets))
        }
        
        if Storage.preferences.useSets {
            var setPresets = [Preset]()
            setPresets.append(ImgSetPreset(name: "Iconset", sizes: macIconset))
            
            var favicon = [Preset]()
            favicon.append(ImgSetPreset(name: "PNGs", sizes: faviconSet))
            favicon.append(FilePreset(name: "ICO", filetype: .ico(faviconIcoSet), prefix: false))
            setPresets.append(CollectionPreset(name: "Favicon", subpresets: favicon))
            
            presets.append(PresetGroup(title: "Sets", presets: setPresets))
        }
    }
    
}

struct PresetGroup {
    var title: String
    var presets: [Preset]
}
