//
//  BinarySetPreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/31/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics
import Foundation

struct PngPreset: Preset {
    var name: String = "png"
    var enabledMods: EnabledModifications = .all
    var defaultMods: DefaultModifications = .zeros
    
    // png uses user defined size
    var aspect: CGSize = .zero
    var maxSize: CGSize? = nil
    
    var id = UUID()
    
    func save(_ image: CGImage) -> URL? {
        guard let fileUrl = SavePanel.file(type: .png) else { return nil }
        try! image.savePng(to: fileUrl)
        return fileUrl
    }
}

struct IcnsPreset: Preset {
    var name: String = "icns"
    var aspect: CGSize = .unit
    var enabledMods: EnabledModifications = .all
    var defaultMods: DefaultModifications = .zeros
    
    var maxSize: CGSize? = CGSize(width: 1024, height: 1024)
    
    var id = UUID()
    
    func save(_ image: CGImage) -> URL? {
        guard let fileUrl = SavePanel.file(type: .icns) else { return nil }
        IcnsGenerator.saveIcns(image, at: fileUrl)
        return fileUrl
    }
}

struct IcoPreset: Preset {
    var name: String
    var aspect: CGSize = .unit
    var enabledMods: EnabledModifications = .all
    var defaultMods: DefaultModifications = .zeros
    
    var maxSize: CGSize? { sizes.max(by: { $0.size.width < $1 .size.width })!.size }
    
    var sizes: [ImgSetSize]
    
    var id = UUID()
    
    func save(_ image: CGImage) -> URL? {
        guard let fileUrl = SavePanel.file(type: .ico) else { return nil }
        IcoGenerator.saveIco(image, in: sizes, at: fileUrl)
        return fileUrl
    }
}
