//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

final class CustomPreset: ImgSetPreset, Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case sizes
        case usePrefix
        case aspect
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(sizes, forKey: .sizes)
        try container.encode(usePrefix, forKey: .usePrefix)
        try container.encode(aspect, forKey: .aspect)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let sizes = try container.decode([ImgSetPreset.ImgSetSize].self, forKey: .sizes)
        let usePrefix = try container.decode(Bool.self, forKey: .usePrefix)
        let aspect = try container.decode(NSSize.self, forKey: .aspect)
        super.init(name: name, sizes: sizes, usePrefix: usePrefix, aspect: aspect)
    }
    
    override init(name: String, sizes: [ImgSetPreset.ImgSetSize], usePrefix: Bool, aspect: NSSize? = nil) {
        super.init(name: name, sizes: sizes, usePrefix: usePrefix, aspect: aspect)
    }
}

