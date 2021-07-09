//
//  PresetPickerView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/11/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct PresetPickerView: View {
    var presetGroups = defaultPresets
    @Binding var preset: Preset
    
    @EnvironmentObject var store: CustomPresetsStore
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(alignment: .center) {
            Picker("Export As", selection: $preset) {
                ForEach(presetGroups, id: \.name) { group in
                    Divider()
                    ForEach(group.presets) { preset in
                        Text(preset.name)
                            .tag(preset)
                    }
                }
                if store.presets.count > 0 {
                    Divider()
                    ForEach(store.presets) { preset in
                        Text(preset.name)
                            .tag(preset)
                    }
                }
            }.frame(maxWidth: 200)
            
            Button("Edit Custom Presets", action: openPresetEditor)
        }
    }
    
    func openPresetEditor() {
        // workaround to open a new window until that functionality gets added to swiftui
        openURL(URL(string: "iconology://custom-presets-editor")!)
    }
}
