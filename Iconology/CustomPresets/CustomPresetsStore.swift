//
//  CustomPresetsStore.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/5/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation
import Combine

class CustomPresetsStore: ObservableObject {
    
    @Published var presets: [ImgSetPreset] = []
    private var changedSub: AnyCancellable?
    
    init() {
        // load or set to default if first time
        if let data = FileManager.default.contents(atPath: databaseFileUrl.path) {
            presets = load(from: data)
        } else {
            presets = [Self.includedCustom]
        }
        
        // save after 1 second of changing
        changedSub = $presets
            .debounce(for: .seconds(1), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: save)
    }
    
    private static let includedCustom = ImgSetPreset(
        name: "Powers of Two",
        sizes: [
            ImgSetSize(name: "16", w: 16, h: 16),
            ImgSetSize(name: "24", w: 24, h: 24),
            ImgSetSize(name: "32", w: 32, h: 32),
            ImgSetSize(name: "48", w: 48, h: 48),
            ImgSetSize(name: "64", w: 64, h: 64),
            ImgSetSize(name: "96", w: 96, h: 96),
            ImgSetSize(name: "128", w: 128, h: 128),
            ImgSetSize(name: "512", w: 512, h: 512),
            ImgSetSize(name: "1024", w: 1024, h: 1024),
            ImgSetSize(name: "2048", w: 2048, h: 2048)
        ],
        aspect: .unit,
        enabledModifications: .all
    )
    
    // MARK: - Persistance
    func save(presets: [ImgSetPreset]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(presets)
            if FileManager.default.fileExists(atPath: databaseFileUrl.path) {
                try FileManager.default.removeItem(at: databaseFileUrl)
            }
            try data.write(to: databaseFileUrl)
        } catch {
            print("ERR: Save Failed \(error)")
        }
    }
    
    private func load(from storeFileData: Data) -> [ImgSetPreset] {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ImgSetPreset].self, from: storeFileData)
        } catch {
            // TODO: try decoding the 1.0 way and then resave
            print("ERR: Load Failed \(error)")
            return []
        }
    }
    
    private let databaseFileUrl = FileManager.applicationSupportDir.appendingPathComponent("custom_presets.json")
}

extension FileManager {
    static var applicationSupportDir: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }
}
