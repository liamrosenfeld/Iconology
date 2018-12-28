//
//  UserPresets.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

struct UserPresets {
    static var presets: [CustomPreset] = []
    
    static func addPreset(name: String, sizes: [ImgSetPreset.ImgSetSize], usePrefix: Bool) {
        let preset = CustomPreset(name: name, sizes: sizes, usePrefix: usePrefix)
        presets.append(preset)
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
            print(success ? "Successful save" : "ERR: Save Failed")
        } catch {
            print("ERR: Save Failed -- \(error)")
        }
    }
    
    static func loadPresets() {
        guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return }
        do {
            let retrievedPresets = try PropertyListDecoder().decode([CustomPreset].self, from: data)
            presets = retrievedPresets
            print("Successful Retrieve")
        } catch {
            print("ERR: Retrieve Failed -- \(error)")
        }
    }
    
    static func deleteAllPreset() {
        do {
            try FileManager.default.removeItem(atPath: filePath)
            print("Sucessful Delete")
        } catch {
            print("ERR: Delete Failed -- \(error)")
        }
    }
    
}
