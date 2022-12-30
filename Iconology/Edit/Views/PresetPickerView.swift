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
    @Binding var size: CGSize
    @Binding var aspect: CGSize
    
    @State private var customSize = false
    
    @EnvironmentObject var store: CustomPresetsStore
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack(alignment: .center) {
            VStack {
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
                
                if customSize {
                    HStack {
                        Text("@")
                        TextField("Width", value: $size.width, formatter: .floatFormatter)
                        Image(systemName: "xmark")
                        TextField("Height", value: $size.height, formatter: .floatFormatter)
                        Text("px")
                    }.frame(maxWidth: 175)
                } else {
                    Text("Largest Size: \(size.width.toIntString())\(Image(systemName: "xmark"))\(size.height.toIntString()) (\(preset.aspect.width.toIntString()):\(preset.aspect.height.toIntString()))")
                }
            }
            Button("Edit Custom Presets", action: openPresetEditor)
        }
        .onChange(of: preset, perform: sizeFromPreset)
        .onChange(of: size, perform: sizeChanged)
        .onAppear { sizeFromPreset(preset) }
    }
    
    func sizeFromPreset(_ preset: Preset) {
        // set the size to largest output of preset
        switch preset.type {
        case .xcodeAsset(let sizes, _):
            let max = sizes.max(by: { a, b in
                a.size.width * CGFloat(a.scale) < b.size.width * CGFloat(b.scale)
            })!
            size = max.size * CGFloat(max.scale)
        case .imgSet(let sizes):
            size = sizes.max(by: { $0.size.width < $1 .size.width })!.size
        case .png:
            customSize = true
            return
        case .icns:
            size = CGSize(width: 1024, height: 1024)
        case .ico(let sizes):
            size = sizes.max(by: { $0.size.width < $1 .size.width })!.size
        }
        
        aspect = preset.aspect
        customSize = false
    }
    
    func sizeChanged(_ new: CGSize) {
        if customSize {
            // get aspect ratio from size
            let gcd = CGFloat.gcd(new.width, new.height)
            aspect = new / gcd
        }
    }

    func openPresetEditor() {
        // workaround to open a new window until that functionality gets added to swiftui
        openURL(URL(string: "iconology://custom-presets-editor")!)
    }
}

// prevent constant reloads
extension PresetPickerView: Equatable {
    static func ==(lhs: PresetPickerView, rhs: PresetPickerView) -> Bool {
        lhs.preset == rhs.preset
    }
}

extension CGFloat {
    func toIntString() -> String {
        Formatter.intFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    static func gcd(_ m: CGFloat, _ n: CGFloat) -> CGFloat {
        // euclid's algorithm implemented iteratively
        var a: CGFloat = 0
        var b = maximum(m, n)
        var r = maximum(m, n)
        
        while r != 0 {
            a = b
            b = r
            r = a.truncatingRemainder(dividingBy: b)
        }
        return b
    }
}

