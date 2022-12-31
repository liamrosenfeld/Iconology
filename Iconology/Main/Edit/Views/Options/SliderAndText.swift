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
    let defaultVal: CGFloat
    let unit: String

    var body: some View {
        HStack {
            Button {
                value = defaultVal
            } label: {
                Image(systemName: "arrow.counterclockwise")
            }
            .accessibility(label: Text("Reset"))
            .dontRedraw()
            
            Slider(value: $value, in: range)
            
            TextField(name, value: $value, formatter: .floatFormatter) // TODO: bound to range
                .frame(width: 50)
            
            Text(unit)
        }
    }
}

extension SliderAndText: Equatable {
    static func == (lhs: SliderAndText, rhs: SliderAndText) -> Bool {
        lhs.value == rhs.value
    }
}
