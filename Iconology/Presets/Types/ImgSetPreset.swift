//
//  ImgSetPreset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import CoreGraphics
import Foundation

struct ImgSetPreset: Preset {
    var name: String
    var sizes: [ImgSetSize]
    var aspect: CGSize
    
    var enabledModifications: EnabledModifications = .all
    var maxSize: CGSize? {
        sizes.max(by: { $0.size.width < $1.size.width })!.size
    }
    var id = UUID()
    
    func save(_ image: CGImage) -> URL? {
        // get where to save
        guard let (parentUrl, prefix) = SavePanel.folderAndPrefix() else { return nil }
        let saveUrl = parentUrl.appendingPathComponent("Icons")
        
        // save files there
        try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
        ImgSetGenerator.savePngs(image, at: saveUrl, with: prefix, in: sizes)
        
        return saveUrl
    }
}

extension ImgSetPreset: Codable { }

struct ImgSetSize: Hashable, Codable, Identifiable {
    var name: String
    var size: CGSize
    
    var id = UUID()

    init(name: String, w: Int, h: Int) {
        self.name = name
        size = CGSize(width: w, height: h)
    }

    init(name: String, size: CGSize) {
        self.name = name
        self.size = size
    }
}
