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
        VStack(alignment: .leading, spacing: 3) {
            Text("Image Adjustments")
                .font(.title)
                .padding(.bottom)
            
                if enabled.background {
                    BackgroundEditor(background: $mods.background)
                }
                
                if enabled.scale {
                    Group {
                        Text("Scale")
                            .font(.title2)
                            .padding(.top)
                        SliderAndText(name: "Scale", value: $mods.scale, range: 10...200, defaultVal: 100, unit: "%")
                    }
                }
                
                if enabled.shift {
                    ShiftEditor(shift: $mods.shift, aspect: mods.aspect)
                }

                if enabled.round {
                    Group {
                        Text("Rounding")
                            .font(.title2)
                            .padding(.top)
                        Picker("Style", selection: $mods.rounding.style) {
                            Text("Circular")
                                .tag(RoundingStyle.circular)
                            Text("Continuous")
                                .tag(RoundingStyle.continuous)
                            Text("Squircle")
                                .tag(RoundingStyle.squircle)
                        }
                        SliderAndText(name: "Rounding", value: $mods.rounding.percent, range: 0...100, defaultVal: 0, unit: "%")
                        Text("45% and Continuous for macOS 11+ Icons")
                    }
                }
                
                if enabled.padding {
                    Group {
                        Text("Padding")
                            .font(.title2)
                            .padding(.top)
                        SliderAndText(name: "Padding", value: $mods.padding, range: 0...75, defaultVal: 0, unit: "%")
                        Text("19.5% for macOS 11+ Icons")
                    }
                }
                
                if enabled.shadow {
                    Group {
                        Text("Shadow")
                            .font(.title2)
                            .padding(.top)
                        Text("Opacity")
                            .font(.title3)
                        SliderAndText(name: "Opacity", value: $mods.shadow.opacity, range: 0...100, defaultVal: 0, unit: "%")
                        Text("30% for macOS 11+ Icons")
                        Text("Blur")
                            .font(.title3)
                        SliderAndText(name: "Blur", value: $mods.shadow.blur, range: 0...100, defaultVal: 0, unit: "%")
                        Text("24% for macOS 11+ Icons")
                    }
                }
            }
    }
}

struct BackgroundEditor: View {
    @Binding var background: Background

    var body: some View {
        Group {
            HStack(alignment: .center) {
                Text("Background")
                    .font(.title2)
                
                Picker("Background Type", selection: $background) {
                    Text("None")
                        .tag(Background.none)
                    Text("Color")
                        .tag(Background.color(.white))
                    Text("Gradient")
                        .tag(Background.gradient(.default))
                }.labelsHidden()
            }
            
            switch background {
            case .color(_):
                ColorPicker("Background Color", selection: $background.color)
                    .labelsHidden()
            case .gradient(_):
                SliderAndText(name: "Angle", value: $background.gradient.angle, range: -90...90, defaultVal: 0, unit: "°")
                HStack {
                    ColorPicker("Top", selection: $background.gradient.topColor)
                    ColorPicker("Bottom", selection: $background.gradient.bottomColor)
                }
            case .none:
                EmptyView()
            }
        }
    }
}

struct ShiftEditor: View {
    @Binding var shift: CGPoint
    var aspect: CGSize
    
    var body: some View {
        Group {
            Text("Shift")
                .font(.title2)
                .padding(.top)
            HStack {
                TwoDimensionSlider(position: $shift)
                    .aspectRatio(aspect, contentMode: .fit)
                VStack {
                    HStack {
                        Text("X:")
                        TextField("X Position", value: $shift.x, formatter: .floatFormatter) // TODO: bound to range
                            .frame(width: 50)
                        Text("%")
                    }
                    HStack {
                        Text("Y:")
                        TextField("Y Position", value: $shift.y, formatter: .floatFormatter )
                            .frame(width: 50)
                        Text("%")
                    }
                    Button {
                        shift = .zero
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
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
    let unit: String

    var body: some View {
        HStack {
            Button {
                value = defaultVal
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }.accessibility(label: Text("Reset"))
            
            Slider(value: $value, in: range)
            
            TextField(name, value: $value, formatter: .floatFormatter) // TODO: bound to range
                .frame(width: 50)
            
            Text(unit)
        }
    }
}

extension Formatter {
    static let floatFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.hasThousandSeparators = false
        return formatter
    }()
    
    static let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.hasThousandSeparators = false
        return formatter
    }()
}

struct EditOptions_Previews: PreviewProvider {
    @StateObject static var mods = ImageModifications()
    @State static var enabled = EnabledModifications.all()
    
    static var previews: some View {
        EditOptionsView(mods: mods, enabled: enabled)
            .padding()
            .frame(width: 275, height: 750)
    }
}

