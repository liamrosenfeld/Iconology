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
                .padding(.bottom)

            if enabled.background {
                Group {
                    Text("Background")
                        .font(.title2)
                    HStack(alignment: .center) {
                        Toggle("Use Background", isOn: $mods.useBackground)
                        
                        ColorPicker("Background Color", selection: $mods.background)
                            .disabled(!mods.useBackground)
                    }
                    .labelsHidden()
                    .padding(.bottom)
                }
            }

            if enabled.scale {
                Group {
                    Text("Scale")
                        .font(.title2)
                    SliderAndText(name: "Scale", value: $mods.scale, range: 10...200, defaultVal: 100)
                        .padding(.bottom)
                }
            }

            if enabled.shift {
                Group {
                    Text("Shift")
                        .font(.title2)
                    HStack {
                        PositionSelector(position: $mods.shift)
                            .aspectRatio(mods.aspect, contentMode: .fit)
                        VStack {
                            PositionInput(position: $mods.shift)
                            Button {
                                mods.shift = .zero
                            } label: {
                                Image(systemName: "arrow.counterclockwise")
                            }
                        }
                        
                    }.padding(.bottom)
                }
            }

            if enabled.round {
                Group {
                    Text("Rounding")
                        .font(.title2)
                    SliderAndText(name: "Rounding", value: $mods.rounding, range: 0...100, defaultVal: 0)
                    Text("45.3% for macOS 11+ Icons")
                        .padding(.bottom)
                }
            }

            if enabled.padding {
                Group {
                    Text("Padding")
                        .font(.title2)
                    SliderAndText(name: "Padding", value: $mods.padding, range: 0...75, defaultVal: 0)
                    Text("19.5% for macOS 11+ Icons")
                        .padding(.bottom)
                }
            }
            
            if enabled.shadow {
                Group {
                    Text("Shadow")
                        .font(.title2)
                    Text("Opacity")
                    SliderAndText(name: "Opacity", value: $mods.shadow.opacity, range: 0...100, defaultVal: 0)
                    Text("30% for macOS 11+ Icons")
                    Text("Blur")
                    SliderAndText(name: "Blur", value: $mods.shadow.blur, range: 0...100, defaultVal: 0)
                    Text("24% for macOS 11+ Icons")
                }
            }
        }
    }
}

struct SliderAndText: View {
    let name: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let defaultVal: CGFloat

    var body: some View {
        HStack {
            Button {
                value = defaultVal
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            
            Slider(value: $value, in: range)
            
            TextField(name, value: $value, formatter: .floatFormatter) // TODO: bound to range
                .frame(width: 50)
            
            Text("%")
        }
    }
}

extension Formatter {
    static let floatFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}

struct EditOptions_Previews: PreviewProvider {
    @StateObject static var mods = ImageModifications()
    @State static var enabled = EnabledModifications.all()
    
    static var previews: some View {
        EditOptionsView(mods: mods, enabled: enabled)
            .padding()
            .frame(width: 300, height: 800)
    }
}

