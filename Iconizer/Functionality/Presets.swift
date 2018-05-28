//
//  Presets.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

class Preset: NSObject, NSCoding {
    
    var name: String
    var sizes: [String : [Int]]  // 0 = x  &  1 = y
    var usePrefix: Bool
    
    init(name: String, sizes: Dictionary<String, [Int]>, usePrefix: Bool) {
        self.name = name
        self.sizes = sizes
        self.usePrefix = usePrefix
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.sizes = aDecoder.decodeObject(forKey: "sizes") as? Dictionary<String, [Int]> ?? ["ERROR": [1, 1]]
        self.usePrefix = aDecoder.decodeObject(forKey: "usePrefix") as? Bool ?? false
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(sizes, forKey: "sizes")
        aCoder.encode(usePrefix, forKey: "usePrefix")
    }
    
}

class UserPresets {
    
    static var presets: [Preset] = []
    
    static func addPreset(name: String, sizes: Dictionary<String, [Int]>, usePrefix: Bool) {
        presets.append(Preset(name: name, sizes: sizes, usePrefix: usePrefix))
    }
    
    static func savePresets() {
        let prefixData = NSKeyedArchiver.archivedData(withRootObject: presets)
        UserDefaults.standard.set(prefixData, forKey: "presets")
    }
    
    static func loadPresets() {
        guard let presetsData = UserDefaults.standard.object(forKey: "presets") as? NSData else {
            print("presets not found")
            return
        }
        
        guard let presetsRetrieved = NSKeyedUnarchiver.unarchiveObject(with: presetsData as Data) as? [Preset] else {
            print("Could not unarchive from placesData")
            return
        }
        
        presets = presetsRetrieved
    }
}
