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
                .font(.title3.bold())
            
            Group {
                Divider().padding([.top, .bottom], 10)
                
                SliderAndText(name: "Image Scale", value: $mods.scale, range: 1...200, bold: true)
                    .disabled(!enabled.scale)
                
                Divider().padding([.top, .bottom], 10)
                
                ShiftEditor(shift: $mods.shift, aspect: aspect).equatable()
                    .disabled(!enabled.shift)
            }
            
            Group {
                Divider().padding([.top, .bottom], 10)
                
                BackgroundEditor(background: $mods.background)
                    .disabled(!enabled.background)
                
                Divider().padding([.top, .bottom], 10)

                RoundingEditor(rounding: $mods.rounding)
                    .disabled(!enabled.round)
                
                Divider().padding([.top, .bottom], 10)
                
                SliderAndText(name: "Padding", value: $mods.padding, range: 0...75, bold: true)
                    .disabled(!enabled.padding)
                
                Divider().padding([.top, .bottom], 10)
                
                ShadowEditor(shadow: $mods.shadow)
                    .disabled(!enabled.shadow)
            }
            
            Divider().padding([.top, .bottom], 10)
            
            ColorSpaceEditor(colorSpace: $mods.colorSpace)
            
            Spacer()
        }
    }
}

struct BackgroundEditor: View {
    @Binding var background: Background

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("Background")
                    .fontWeight(.semibold)
                
                Picker("Background Type", selection: $background) {
                    Text("None")
                        .tag(Background.none)
                    Text("Color")
                        .tag(Background.color(.white))
                    Text("Gradient")
                        .tag(Background.gradient(.default))
                }.labelsHidden()
            }
            
            Spacer()
            
            switch background {
            case .color(_):
                ColorPicker("Background Color", selection: $background.color)
                    .labelsHidden()
            case .gradient(_):
                GradientEditor(gradient: $background.gradient)
            case .none:
                ColorPicker("Background Color", selection: Binding.constant(CGColor(red: 1, green: 1, blue: 1, alpha: 0)))
                    .labelsHidden()
                    .disabled(true)
            }
        }
        .frame(height: 55) // keep things from shifting when mode switches
    }
}

struct RoundingEditor: View {
    @Binding var rounding: Rounding
    
    var body: some View {
        Group {
            SliderAndText(name: "Rounding", value: $rounding.percent, range: 0...100, bold: true)

            Picker("Style", selection: $rounding.style) {
                Text("Circular")
                    .tag(RoundingStyle.circular)
                Text("Continuous")
                    .tag(RoundingStyle.continuous)
                Text("Squircle")
                    .tag(RoundingStyle.squircle)
            }.padding(.top, 5)
        }
    }
}

struct ShadowEditor: View {
    @Binding var shadow: ShadowAttributes
    
    var body: some View {
        Group {
            Text("Shadow")
                .fontWeight(.semibold)
                .padding(.bottom, 4)
            
            SliderAndText(name: "Opacity", value: $shadow.opacity, range: 0...100, bold: false)
            
            SliderAndText(name: "Blur", value: $shadow.blur, range: 0...100, bold: false)
        }
    }
}

struct ColorSpaceEditor: View {
    @Binding var colorSpace: CGColorSpace
    
    var body: some View {
        Group {
            Text("Color Space")
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            
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

