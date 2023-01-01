//
//  CustomPresetSelector.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/6/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetSelector: View {
    @Binding var selection: ImgSetPreset.ID?
    
    @State private var importError = false
    
    @EnvironmentObject var store: CustomPresetsStore
    @FocusState private var sidebarFocused: Bool
    
    var body: some View {
        List($store.presets, selection: $selection) { $preset in
            PresetNameEdit(
                preset: $preset,
                selection: $selection,
                sidebarFocused: $sidebarFocused
            )
        }
        .focused($sidebarFocused)
        .toolbar {
            Button(action: addPreset) {
                Label("New Preset", systemImage: "plus")
            }
            Button(action: removePreset) {
                Label("Remove Preset", systemImage: "minus")
            }
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
            perform: { _ in addPreset()}
        )
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetImport),
            perform: { _ in importPreset()}
        )
    }
    
    func addPreset() {
        var n = 1
        while store.presets.contains(where: { $0.name == "Preset \(n)" }) {
            n += 1
        }
        let newPreset = ImgSetPreset(
            name: "Preset \(n)",
            sizes: [ImgSetSize(name: "Size 1", size: .unit)],
            aspect: .unit
        )
        store.presets.append(newPreset)
    }
    
    func removePreset() {
        guard let id = selection else { return }
        
        // remove
        let index = store.presets.indexWithId(id)
        store.presets.remove(at: index)
        
        // adapt selection
        if store.presets.count > 0 {
            // FIXME: not triggering onchange in edit view when last row
            selection = store.presets[max(index - 1, 0)].id
        } else {
            selection = nil
        }
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
        preset.id = UUID() // give new ID so an export then import does not break things
        store.presets.append(preset)
    }
}

struct PresetNameEdit: View {
    @Binding var preset: ImgSetPreset
    @Binding var selection: ImgSetPreset.ID?
    var sidebarFocused: FocusState<Bool>.Binding
    
    // internal
    @State private var editing = false
    @FocusState private var fieldFocused: Bool
    
    public var body: some View {
        ZStack(alignment: .leading) {
            Text(preset.name)
                .opacity(editing ? 0 : 1)
            TextField("Preset Name", text: $preset.name)
                .focused($fieldFocused)
                .opacity(editing ? 1 : 0)
        }
        .onTapGesture {
            // fix for the row not selecting when text is clicked
            selection = preset.id // select the row
            sidebarFocused.wrappedValue = true // focus the list
        }
        .simultaneousGesture(TapGesture(count: 2).onEnded {
            editing = true
            fieldFocused = true
        })
        .onChange(of: fieldFocused) { newValue in
            editing = newValue
        }
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
