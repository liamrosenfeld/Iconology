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

    var body: some View {
        Picker("Preset", selection: $preset) {
            ForEach(presetGroups, id: \.name) { group in
                Divider()
                ForEach(group.presets, id: \.name) { preset in
                    Text(preset.name)
                        .tag(preset)
                }
            }
        }
    }
}
