//
//  Presets.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

class Presets {
    struct Preset: Hashable {
        var name: String
        var sizes: [String : (x: Int, y: Int)]
        var usePrefix: Bool
        var hashValue: Int { return name.hashValue }
        
        static func == (lhs: Presets.Preset, rhs: Presets.Preset) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    static var presets : [Preset] = []
    
    static func addPreset(name: String, sizes: Dictionary<String, (x: Int, y: Int)>, usePrefix: Bool) {
        presets.append(Preset(name: name, sizes: sizes, usePrefix: usePrefix))
    }
    
}
