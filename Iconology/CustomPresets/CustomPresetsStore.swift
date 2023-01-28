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
    
    @Published var presetSelection: ImgSetPreset.ID?
    @Published var sizeSelection: ImgSetSize.ID?
    
    private(set) var presetIndex: Int?
    
    private var subs = Set<AnyCancellable>()
    
    init() {
        load()
        
        // save after 3 second of not changing
        $presets
            .debounce(for: .seconds(3), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: save)
            .store(in: &subs)
        
        // sync index
        $presetSelection
            .sink { id in
                if let id {
                    self.presetIndex = self.presets.indexWithId(id)
                } else {
                    self.presetIndex = nil
                }
            }
            .store(in: &subs)
    }
    
    func reset() {
        presets = [Self.includedCustom]
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
        aspect: .unit
    )
    
    // MARK: - Creation/Removal
    func addPreset() {
        // find name that does not conflict
        var n = 1
        while presets.contains(where: { $0.name == "Preset \(n)" }) {
            n += 1
        }
        
        let newPreset = ImgSetPreset(
            name: "Preset \(n)",
            sizes: [ImgSetSize(name: "Size 1", size: .unit)],
            aspect: .unit
        )
        
        addPreset(newPreset)
    }
    
    func addPreset(_ preset: ImgSetPreset) {
        // insert
        let index = {
            if let selection = presetSelection,
               let selectionIndex = presets.indexWithId(selection) {
                return selectionIndex + 1
            } else {
                return presets.count
            }
        }()
        
        presets.insert(preset, at: index)
        
        // adjust selection
        presetSelection = preset.id
        
        // register undo
        registerNewPresetUndo(newPresetIndex: index)
    }
    
    func removePreset() {
        guard let index = presetIndex else { return }
        removePreset(at: index)
    }
    
    private func removePreset(at index: Int) {
        let removed = presets.remove(at: index)
        
        // adapt selection
        if presets.count > 0 {
            presetSelection = presets[max(index - 1, 0)].id
        } else {
            presetSelection = nil
        }
        
        registerRemovePresetUndo(presetIndex: index, removed: removed)
    }
    
    func addSize() {
        guard let index = presetIndex else { return }
        addSize(to: &presets[index])
    }
    
    func addSize(to preset: inout ImgSetPreset) {
        // find name that does not conflict
        var n = 1
        while preset.sizes.contains(where: { $0.name == "Size \(n)" }) {
            n += 1
        }
        
        // add
        let new = ImgSetSize(name: "Size \(n)", size: preset.aspect)
        let sizeIndex = {
            if let sizeSelection,
               let selectionIndex = preset.sizes.indexWithId(sizeSelection)
            {
                return selectionIndex + 1
            } else {
                return preset.sizes.count
            }
        }()
        
        preset.sizes.insert(new, at: sizeIndex)
        sizeSelection = new.id
        
        // register undo
        registerNewSizeUndo(preset: preset.id, sizeIndex: sizeIndex)
    }
    
    func removeSize() {
        guard let presetIndex,
              let sizeSelection,
              let sizeIndex = presets[presetIndex].sizes.indexWithId(sizeSelection)
        else { return }
        
        removeSize(index: sizeIndex, preset: &presets[presetIndex])
    }
    
    private func removeSize(index: Int, preset: inout ImgSetPreset) {
        // do not allow to delete the last size
        if preset.sizes.count == 1 {
            return
        }
        
        // delete
        let removed = preset.sizes.remove(at: index)
        self.sizeSelection = preset.sizes[max(index - 1, 0)].id
        
        // register undo
        registerRemoveSizeUndo(preset: preset.id, sizeIndex: index, removed: removed)
    }
    
    // MARK: - Undo/Redo
    var undoManager: UndoManager?
    
    func registerNewPresetUndo(newPresetIndex: Int) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // also registers redo
            handler.removePreset(at: newPresetIndex)
        }
    }
    
    func registerRemovePresetUndo(presetIndex: Int, removed: ImgSetPreset) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            handler.presets.insert(removed, at: presetIndex)
            
            // set selection to reinserted element
            handler.presetSelection = removed.id
            
            // enable redo
            handler.registerNewPresetUndo(newPresetIndex: presetIndex)
        }
    }
    
    func registerPresetRename(preset: UUID, old: String, new: String) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset) else { return }
            handler.presets[presetIndex].name = old
            
            // select modified preset
            handler.presetSelection = preset
            
            // enable redo
            handler.registerPresetRename(preset: preset, old: new, new: old)
        }
    }
    
    func registerNewSizeUndo(preset: UUID, sizeIndex: Int) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // focus preset that will change
            handler.presetSelection = preset
            
            // apply undo
            // also registers redo
            guard let presetIndex = handler.presets.indexWithId(preset) else { return }
            handler.removeSize(index: sizeIndex, preset: &handler.presets[presetIndex])
        }
    }
    
    func registerRemoveSizeUndo(preset: UUID, sizeIndex: Int, removed: ImgSetSize) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset) else { return }
            handler.presets[presetIndex].sizes.insert(removed, at: sizeIndex)
            
            // set selection to reinserted element
            handler.presetSelection = preset
            handler.sizeSelection = removed.id
            
            // enable redo
            handler.registerNewSizeUndo(preset: preset, sizeIndex: sizeIndex)
        }
    }
    
    func registerSizeDimUndo(preset: UUID, size: UUID, old: CGSize, new: CGSize) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset),
                  let sizeIndex = handler.presets[presetIndex].sizes.indexWithId(size) else { return }
            handler.presets[presetIndex].sizes[sizeIndex].size = old
            
            // set selection to modified size
            handler.presetSelection = preset
            handler.sizeSelection = size
            
            // enable redo
            handler.registerSizeDimUndo(preset: preset, size: size, old: new, new: old)
        }
    }
    
    func registerSizeNameUndo(preset: UUID, size: UUID, old: String, new: String) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset),
                  let sizeIndex = handler.presets[presetIndex].sizes.indexWithId(size) else { return }
            handler.presets[presetIndex].sizes[sizeIndex].name = old
            
            // set selection to modified size
            handler.presetSelection = preset
            handler.sizeSelection = size
            
            // enable redo
            handler.registerSizeNameUndo(preset: preset, size: size, old: new, new: old)
        }
    }
    
    func registerAspectWidthUndo(preset: UUID, old: CGFloat, new: CGFloat) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset) else { return }
            handler.presets[presetIndex].aspect.width = old
            
            // set selection to modified preset
            handler.presetSelection = preset
            // TODO: maybe open the aspect editor too
            
            // enable redo
            handler.registerAspectWidthUndo(preset: preset, old: new, new: old)
            
            // update sizes to match
            handler.presets[presetIndex].applyAspectKeepHeight()
        }
    }
    
    func registerAspectHeightUndo(preset: UUID, old: CGFloat, new: CGFloat) {
        undoManager?.registerUndo(withTarget: self) { handler in
            // apply undo
            guard let presetIndex = handler.presets.indexWithId(preset) else { return }
            handler.presets[presetIndex].aspect.height = old
            
            // set selection to modified preset
            handler.presetSelection = preset
            
            // enable redo
            handler.registerAspectHeightUndo(preset: preset, old: new, new: old)
            
            // update sizes to match
            handler.presets[presetIndex].applyAspectKeepWidth()
        }
    }
    
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
    
    private func load() {
        // load persistent data
        if let data = FileManager.default.contents(atPath: databaseFileUrl.path) {
            presets = decode(from: data)
        }
        // fallback: load from v1 (on initial update)
        else if let oldData = FileManager.default.contents(atPath: databaseOldFileUrl.path) {
            presets = decodeOld(from: oldData)
        }
        // fallback: set to default (on first run)
        else {
            presets = [Self.includedCustom]
        }
    }
    
    private func decode(from data: Data) -> [ImgSetPreset] {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([ImgSetPreset].self, from: data)
        } catch {
            print("ERR: Load Failed \(error)")
            return []
        }
    }
    
    private func decodeOld(from data: Data) -> [ImgSetPreset] {
        // this is how v1 does it
        struct OldCustomPreset: Codable {
            var name: String
            var sizes: [OldSize]
            var aspect: CGSize

            struct OldSize: Codable {
                var name: String
                var size: CGSize
            }
        }
        
        do {
            let unarchived = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! Data
            let oldPresets = try PropertyListDecoder().decode([OldCustomPreset].self, from: unarchived)
            return oldPresets.map { old in
                ImgSetPreset(
                    name: old.name,
                    sizes: old.sizes.map { oldSize in
                        ImgSetSize(name: oldSize.name, size: oldSize.size)
                    },
                    aspect: old.aspect
                )
            }
        } catch {
            print("ERR: Load OLD Failed \(error)")
            return []
        }
    }
    
    private let databaseFileUrl = FileManager.applicationSupportDir.appendingPathComponent("custom_presets.json")
    private let databaseOldFileUrl = FileManager.documentDir.appendingPathComponent("Data")
}

extension FileManager {
    static var applicationSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    static var documentDir           = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
