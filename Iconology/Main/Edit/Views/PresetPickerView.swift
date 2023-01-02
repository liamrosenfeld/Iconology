//
//  PresetPickerView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/11/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct PresetPickerView: View {
    @ObservedObject var selection: PresetSelection
    @EnvironmentObject var customPresets: CustomPresetsStore

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Picker("Export As", selection: $selection.selection) {
                    ForEach(includedPresets, id: \.name) { group in
                        Divider()
                        ForEach(group.presets, id: \.id) { preset in
                            Text(preset.name)
                                .tag(preset.id)
                        }
                    }
                    if customPresets.presets.count > 0 {
                        Divider()
                        ForEach(customPresets.presets) { preset in
                            Text(preset.name)
                                .tag(preset.id)
                        }
                    }
                }.frame(maxWidth: 200)
                
                if selection.customSize {
                    HStack {
                        Text("@")
                        TextField("Width", value: $selection.size.width, formatter: .floatFormatter)
                        Image(systemName: "xmark")
                        TextField("Height", value: $selection.size.height, formatter: .floatFormatter)
                        Text("px")
                    }.frame(maxWidth: 175)
                } else {
                    Text("(Largest Size: \(selection.size.width.toIntString())×\(selection.size.height.toIntString()))")
                }
            }
        }
        .onAppear {
            selection.customPresets = customPresets
        }
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

