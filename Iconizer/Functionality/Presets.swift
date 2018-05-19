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
        var sizes: [String : Array<Int>] // 0 = X  &  1 = Y
        var usePrefix: Bool
        var hashValue: Int { return name.hashValue }
    }
    
    static var presets : [Preset] = []
    
    static func addPreset(name: String, sizes: Dictionary<String, Array<Int>>, usePrefix: Bool) {
        presets.append(Preset(name: name, sizes: sizes, usePrefix: usePrefix))
    }
    
}
