//
//  CustomPresetSelector.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/6/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetSelector: View {
    @EnvironmentObject var store: CustomPresetsStore
    @Binding var selection: Preset.ID?
    
    var body: some View {
        List(store.presets, selection: $selection) { preset in
            Text(preset.name)
                .contextMenu {
                    Button {
                        removePreset(id: preset.id)
                    } label: {
                        Label("Delete", image: "trash")
                    }
                }
        }
        .toolbar {
            Button(action: addPreset) {
                Label("Add Size", systemImage: "plus")
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
    
    func removePreset(id: Preset.ID) {
        // remove
        let index = store.presets.indexWithId(id)
        store.presets.remove(at: index)
        
        // adapt selection
        if selection == id {
            if store.presets.count > 0 {
                selection = store.presets[max(index - 1, 0)].id
            } else {
                selection = nil
            }
        }
    }
}
