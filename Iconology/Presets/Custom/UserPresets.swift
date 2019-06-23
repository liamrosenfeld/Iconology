//
//  UserPresets.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct UserPresets {
    var presets: [CustomPreset] = []
    
    mutating func addPreset(name: String, sizes: [ImgSetPreset.ImgSetSize], prefix: Bool) {
        let preset = CustomPreset(name: name, sizes: sizes)
        presets.append(preset)
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("Custom Preset Directory: \(url.path)")
        return (url.appendingPathComponent("Data").path)
    }
    
    func savePresets() {
        do {
            let data = try PropertyListEncoder().encode(presets)
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            print(success ? "Successful save" : "ERR: Save Failed")
        } catch {
            print("ERR: Save Failed -- \(error)")
        }
    }
    
    mutating func loadPresets() {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return }
        do {
            let retrievedPresets = try PropertyListDecoder().decode([CustomPreset].self, from: data)
            presets = retrievedPresets
            print("Successful Retrieve")
        } catch {
            print("ERR: Retrieve Failed -- \(error)")
        }
    }
    
    mutating func deleteAllPreset() {
        presets.removeAll()
        do {
            try FileManager.default.removeItem(atPath: filePath)
            print("Sucessful Delete")
        } catch {
            print("ERR: Delete Failed -- \(error)")
        }
    }
    
    init() {
        loadPresets()
    }
    
}
