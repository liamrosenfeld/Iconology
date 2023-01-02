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
    
    var body: some View {
        Group {
            // aligned top because that feels more balanced in this layout
            HStack(alignment: .top) {
                Text(name)
                    .fontWeight(bold ? .semibold : nil)
            
                Spacer()
                
                HStack(spacing: 1) {
                    TextField(name, value: $value, formatter: .floatFormatter)
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
