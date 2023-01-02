//
//  XcodePreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics
import Foundation

struct XcodePreset: Preset {
    var name: String
    var sizes: [XcodeIconSize]
    var folderName: String
    var aspect: CGSize
    var enabledMods: EnabledModifications
    var defaultMods: DefaultModifications
    
    var maxSize: CGSize? {
        let max = sizes.max(by: { a, b in
            a.size.width * CGFloat(a.scale) < b.size.width * CGFloat(b.scale)
        })!
        return max.size * CGFloat(max.scale)
    }
    var id = UUID()
    
    func save(_ image: CGImage) -> URL? {
        // get where to save
        guard let (parentUrl, prefix) = SavePanel.folderAndPrefix() else { return nil }
        let saveUrl = parentUrl.appendingPathComponent(folderName)
        
        // save files there
        try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
        XcodeAssetGenerator.save(image, sizes: sizes, url: saveUrl, prefix: prefix)
        
        return saveUrl
    }
}

struct XcodeIconSize {
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
