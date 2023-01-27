//
//  CustomPresetSelector.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/6/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetSelector: View {
    @State private var importError = false
    
    @EnvironmentObject var store: CustomPresetsStore
    
    var body: some View {
        List($store.presets, selection: $store.presetSelection) { $preset in
            OnCommitTextField("Preset Name", text: $preset.name, onCommit: { (old, new) in
                store.registerPresetRename(preset: preset.id, old: old , new: new)
            })
        }
        .toolbar {
            Button(action: store.addPreset) {
                Label("New Preset", systemImage: "plus")
            }
            
            Button(action: store.removePreset) {
                Label("Remove Preset", systemImage: "minus")
            }
            .disabled(store.presetSelection == nil)
            
            Button(action: importPreset) {
                Label("Import Preset", systemImage: "square.and.arrow.down")
            }
        }
        .alert(
            "File Not Compatible",
            isPresented: $importError,
            actions: { Button("Ok", action: {})},
            message: { Text("Please make sure the imported file was created by Iconology") }
        )
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetNew),
            perform: { _ in store.addPreset()}
        )
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetImport),
            perform: { _ in importPreset()}
        )
    }
    
    func importPreset() {
        // get file
        guard let url = NSOpenPanel().selectPresetBackup() else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        
        // decode
        let decoder = JSONDecoder()
        guard var preset = try? decoder.decode(ImgSetPreset.self, from: data) else {
            importError = true
            return
        }
        
        // add
        preset.id = UUID() // give new ID so multiple imports do not break things
        store.addPreset(preset)
    }
}

fileprivate extension NSOpenPanel {
    func selectPresetBackup() -> URL? {
        self.title = "Select a Preset JSON File"
        self.showsResizeIndicator = true
        self.canChooseDirectories = false
        self.canChooseFiles = true
        self.allowsMultipleSelection = false
        self.canCreateDirectories = true
        self.allowedContentTypes = [.json]
        
        self.runModal()
        return self.url
    }
}
