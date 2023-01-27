//
//  GradientEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/29/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct GradientEditor: View {
    @Binding var gradient: Gradient
    
    static let angleFormatter = Formatter.boundDecimal(min: 0, max: 360)
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            Group {
                ColorPicker("Top", selection: $gradient.topColor)
                    .labelsHidden()
                
                Image(systemName: "arrowshape.right.fill")
                
                ColorPicker("Bottom", selection: $gradient.bottomColor)
                    .labelsHidden()
            }
            
            Spacer()
            
            Group {
                Slider(value: $gradient.angle, in: 0...360)
                    .dialSliderStyle()
                    .frame(maxWidth: 30)
                
                TextField("Gradient Angle", value: $gradient.angle, formatter: Self.angleFormatter)
                    .frame(width: 50)
                
                Text("°")
            }
            
            Spacer()
        }
    }
}

struct GradientEditor_Previews: PreviewProvider {
    @State static var gradient: Gradient = .default
    
    static var previews: some View {
        GradientEditor(gradient: $gradient)
            .padding()
            .frame(width: 275, height: 100)
    }
}
