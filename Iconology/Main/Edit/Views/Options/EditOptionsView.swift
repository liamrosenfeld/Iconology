//
//  EditOptionsView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/9/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditOptionsView: View {
    @ObservedObject var mods: ImageModifier
    var aspect: CGSize
    var enabled: EnabledModifications
    var defaultMods: DefaultModifications

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Image Adjustments")
                .font(.title)
                .padding(.bottom)
            
                if enabled.background {
                    BackgroundEditor(background: $mods.background)
                }
                
                if enabled.scale {
                    ScaleEditor(scale: $mods.scale)
                }
                
                if enabled.shift {
                    ShiftEditor(shift: $mods.shift, aspect: aspect).equatable()
                }

                if enabled.round {
                    RoundingEditor(rounding: $mods.rounding)
                }
                
                if enabled.padding {
                    PaddingEditor(padding: $mods.padding)
                }
                
                if enabled.shadow {
                    ShadowEditor(shadow: $mods.shadow)
                }
            
            ColorSpaceEditor(colorSpace: $mods.colorSpace)
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
                HStack {
                    Spacer()
                    ColorPicker("Background Color", selection: $background.color)
                        .labelsHidden()
                    Spacer()
                }.padding(.top, 10)
            case .gradient(_):
                GradientEditor(gradient: $background.gradient)
                    .padding(.top, 10)
            case .none:
                EmptyView()
            }
        }
    }
}


struct ScaleEditor: View {
    @Binding var scale: CGFloat
    
    var body: some View {
        Group {
            Text("Image Scale")
                .font(.title2)
                .padding(.top)
            SliderAndText(name: "Scale", value: $scale, range: 1...200, defaultVal: 100, unit: "%")
                .equatable()
        }
    }
}

struct RoundingEditor: View {
    @Binding var rounding: Rounding
    
    var body: some View {
        Group {
            Text("Rounding")
                .font(.title2)
                .padding(.top)
            Picker("Style", selection: $rounding.style) {
                Text("Circular")
                    .tag(RoundingStyle.circular)
                Text("Continuous")
                    .tag(RoundingStyle.continuous)
                Text("Squircle")
                    .tag(RoundingStyle.squircle)
            }
            SliderAndText(name: "Rounding", value: $rounding.percent, range: 0...100, defaultVal: 0, unit: "%")
                .equatable()
        }
    }
}

struct PaddingEditor: View {
    @Binding var padding: CGFloat
    
    var body: some View {
        Group {
            Text("Padding")
                .font(.title2)
                .padding(.top)
            SliderAndText(name: "Padding", value: $padding, range: 0...75, defaultVal: 0, unit: "%")
                .equatable()
        }
    }
}

struct ColorSpaceEditor: View {
    @Binding var colorSpace: CGColorSpace
    
    var body: some View {
        Group {
            Text("Color Space")
                .font(.title2)
                .padding(.top)
            
            Picker("Background Type", selection: $colorSpace) {
                Text("sRGB")
                    .tag(CGColorSpace(name: CGColorSpace.sRGB)!)
                Text("Display P3")
                    .tag(CGColorSpace(name: CGColorSpace.displayP3)!)
                Text("Adobe RGB")
                    .tag(CGColorSpace(name: CGColorSpace.adobeRGB1998)!)
            }.labelsHidden()
        }
    }
}

struct ShadowEditor: View {
    @Binding var shadow: ShadowAttributes
    
    var body: some View {
        Group {
            Text("Shadow")
                .font(.title2)
                .padding(.top)
            
            Text("Opacity")
                .font(.title3)
            
            SliderAndText(name: "Opacity", value: $shadow.opacity, range: 0...100, defaultVal: 0, unit: "%")
                .equatable()
            
            Text("Blur")
                .font(.title3)
            
            SliderAndText(name: "Blur", value: $shadow.blur, range: 0...100, defaultVal: 0, unit: "%")
                .equatable()
        }
    }
}


struct EditOptions_Previews: PreviewProvider {
    @StateObject static var mods = ImageModifier()

    static var previews: some View {
        EditOptionsView(
            mods: mods,
            aspect: .init(width: 1, height: 1),
            enabled: .all,
            defaultMods: .zeros
        )
        .padding()
        .frame(width: 275, height: 750)
    }
}

