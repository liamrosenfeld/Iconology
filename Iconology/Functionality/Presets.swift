//
//  Presets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/18/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct Preset: Codable {
    
    var name: String
    var sizes: [String : size]
    var usePrefix: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case sizes
        case usePrefix
    }
    
    init(name: String, sizes: [String : size], usePrefix: Bool) {
        self.name = name
        self.sizes = sizes
        self.usePrefix = usePrefix
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(sizes, forKey: .sizes)
        try container.encode(usePrefix, forKey: .usePrefix)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        sizes = try container.decode(Dictionary.self, forKey: .sizes)
        usePrefix = try container.decode(Bool.self, forKey: .usePrefix)
    }
}

struct size: Codable {
    var x: Int
    var y: Int
}

struct UserPresets {
    
    static var presets: [Preset] = []
    
    static func addPreset(name: String, sizes: Dictionary<String, size>, usePrefix: Bool) {
        presets.append(Preset(name: name, sizes: sizes, usePrefix: usePrefix))
    }
    
    static var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("Document Directory: \(String(describing: url!))")
        return (url!.appendingPathComponent("Data").path)
    }
    
    static func savePresets() {
        do {
            let data = try PropertyListEncoder().encode(presets)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            print(success ? "Successful save" : "Save Failed")
        } catch {
            print("Save Failed")
        }
    }
    
    static func loadPresets() {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return }
        do {
            let retrievedPresets = try PropertyListDecoder().decode([Preset].self, from: data)
            presets = retrievedPresets
            print("Successful Retrieve")
        } catch {
            print("Retrieve Failed")
        }
    }
}

