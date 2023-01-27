//
//  SliderAndText.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/29/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct SliderAndText: View {
    let name: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let bold: Bool
    
    let formatter: Formatter
    
    init(name: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>, bold: Bool) {
        self.name = name
        self._value = value
        self.range = range
        self.bold = bold
        
        // initialize here instead of body to prevent memory usage from exploding on typing
        self.formatter = .boundDecimal(
            min: range.lowerBound,
            max: range.upperBound
        )
    }
    
    var body: some View {
        Group {
            // aligned top because that feels more balanced in this layout
            HStack(alignment: .top) {
                Text(name)
                    .fontWeight(bold ? .semibold : nil)
            
                Spacer()
                
                HStack(spacing: 1) {
                    TextField(name, value: $value, formatter: formatter)
                        .frame(width: 50)
                    Text("%")
                }
            }
            .padding(.bottom, bold ? 2 : 0)
            
            
            Slider(value: $value, in: range)
                .controlSize(.mini)
        }
    }
}
