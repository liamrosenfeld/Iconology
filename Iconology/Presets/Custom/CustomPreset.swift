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
        case aspect
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(sizes, forKey: .sizes)
        try container.encode(aspect, forKey: .aspect)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let sizes = try container.decode([ImgSetPreset.ImgSetSize].self, forKey: .sizes)
        let aspect = try container.decode(NSSize.self, forKey: .aspect)
        super.init(name: name, sizes: sizes, aspect: aspect)
    }
    
    override init(name: String, sizes: [ImgSetPreset.ImgSetSize], aspect: NSSize? = nil) {
        super.init(name: name, sizes: sizes, aspect: aspect)
    }
}

