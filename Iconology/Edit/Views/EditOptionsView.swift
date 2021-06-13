//
//  EditOptionsView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/9/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditOptionsView: View {
    @ObservedObject var mods: ImageModifications
    var enabled: EnabledModifications

    var body: some View {
        VStack(alignment: .leading) {
            Text("Image Adjustments")
                .font(.title)

            if enabled.background {
                Group {
                    HStack {
                        Toggle("Use Background", isOn: $mods.useBackground)
                        Text("Background")
                            .font(.title2)
                    }
                    ColorPicker("Background Color", selection: $mods.background)
                        .padding(.bottom)
                }
            }

            if enabled.scale {
                SliderAndText(name: "Scale", value: $mods.scale, range: 10...200, defaultVal: 100)
            }

            if enabled.shift {
                Group {
                    HStack {
                        Button {
                            mods.shift = .zero
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }

                        Text("Shift")
                            .font(.title2)
                    }
                    HStack {
                        PositionSelector(position: $mods.shift)
                            .aspectRatio(mods.aspect, contentMode: .fit)
                        PositionInput(position: $mods.shift)
                    }.padding(.bottom)
                }
            }

            if enabled.round {
                SliderAndText(name: "Rounding", value: $mods.rounding, range: 0...100, defaultVal: 0)
            }

            if enabled.padding {
                SliderAndText(name: "Padding", value: $mods.padding, range: 0...75, defaultVal: 0)
            }
        }.labelsHidden()
    }
}

struct SliderAndText: View {
    let name: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let defaultVal: CGFloat

    var body: some View {
        Group {
            HStack {
                Button {
                    value = defaultVal
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }

                Text(name)
                    .font(.title2)
            }
            HStack {
                Slider(value: $value, in: range)
                TextField(name, value: $value, formatter: NumberFormatter()) // TODO: bound to range
                    .frame(width: 50)
                Text("%")
            }.padding(.bottom)
        }
    }
}
