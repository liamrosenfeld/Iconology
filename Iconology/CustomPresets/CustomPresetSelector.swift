//
//  CustomPresetSelector.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/6/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetSelector: View {
    @Binding var selection: Preset.ID?
    
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
            // TODO: make these not merge with main window when sidebar is removed (or make sidebar always there)
            Button(action: addPreset) {
                Label("New Preset", systemImage: "plus")
            }
            Button(action: removePreset) {
                Label("Remove Preset", systemImage: "minus")
            }
        }
    }
    
    func addPreset() {
        var n = 1
        while true {
            if !store.presets.contains(where: { $0.name == "New Preset \(n)" }) {
                break
            }
            n += 1
        }
        store.presets.append(Preset.newImgSet(name: "New Preset \(n)"))
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
}

struct PresetNameEdit: View {
    @Binding var preset: Preset
    @Binding var selection: Preset.ID?
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
