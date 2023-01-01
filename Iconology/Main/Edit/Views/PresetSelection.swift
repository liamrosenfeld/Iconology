//
//  PresetSelection.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/31/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import Combine
import SwiftUI

class PresetSelection: ObservableObject {
    @Published private(set) var preset: any Preset
    
    // this selection intermediate step is because
    // 'any Preset' cannot conform to Hashable for the picker
    @Published var selection: UUID
    
    @Published var size: CGSize
    @Published private(set) var aspect: CGSize
    @Published private(set) var customSize: Bool
    
    var customPresets: CustomPresetsStore?
    
    var subscribers = Set<AnyCancellable>()
    
    init() {
        // first preset
        let defaultPreset = includedPresets[0].presets[0]
        self.preset       = defaultPreset
        self.selection    = defaultPreset.id
        
        // will be replaced
        self.size         = .unit
        self.aspect       = .unit
        self.customSize   = false
        
        observe()
        sizeFromPreset(defaultPreset)
    }
    
    func observe() {
        $selection
            .sink(receiveValue: newSelection)
            .store(in: &subscribers)
        $preset
            .sink(receiveValue: sizeFromPreset)
            .store(in: &subscribers)
        $size
            .sink(receiveValue: sizeChanged)
            .store(in: &subscribers)
    }
    
    private func newSelection(_ selection: UUID) {
        // TODO: could change selection to be (groupIdx, presetIdx)
        
        for group in includedPresets {
            for preset in group.presets {
                if preset.id == selection {
                    self.preset = preset
                    return
                }
            }
        }
        if let customPresets {
            for preset in customPresets.presets {
                if preset.id == selection {
                    self.preset = preset
                    return
                }
            }
        }
    }
    
    private func sizeFromPreset(_ preset: any Preset) {
        // set the size to largest output of preset
        if let size = preset.maxSize {
            self.size = size
            self.customSize = false
            self.aspect = preset.aspect
        } else {
            // TODO: should this set the size to some reasonable default (and reset aspect)
            self.customSize = true
        }
    }
    
    private func sizeChanged(_ new: CGSize) {
        if customSize {
            // get aspect ratio from size
            let gcd = CGFloat.gcd(new.width, new.height)
            aspect = new / gcd
        }
    }
}
