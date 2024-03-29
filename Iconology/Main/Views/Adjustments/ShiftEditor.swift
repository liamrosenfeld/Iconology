//
//  ShiftEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/29/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct ShiftEditor: View {
    @Binding var shift: CGPoint
    var aspect: CGSize
    
    static let shiftFormatter = Formatter.boundDecimal(min: -100, max: 100)
    
    var body: some View {
        Group {
            HStack {
                Text("Shift")
                    .fontWeight(.semibold)
                Spacer()
            }
            
            HStack {
                TwoDimensionSlider(position: $shift)
                    .aspectRatio(aspect, contentMode: .fit)
                    .frame(maxWidth: 125, maxHeight: 125)
                VStack {
                    HStack(spacing: 1) {
                        Text("X: ")
                        TextField("X Position", value: $shift.x, formatter: Self.shiftFormatter)
                            .frame(width: 50)
                        Text("%")
                    }
                    HStack(spacing: 1) {
                        Text("Y: ")
                        TextField("Y Position", value: $shift.y, formatter: Self.shiftFormatter)
                            .frame(width: 50)
                        Text("%")
                    }
                    Button {
                        shift = .zero
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .labelStyle(.iconOnly)
                    }
                    .dontRedraw()
                }
                
            }
        }
    }
}

extension ShiftEditor: Equatable {
    static func == (lhs: ShiftEditor, rhs: ShiftEditor) -> Bool {
        lhs.shift == rhs.shift && lhs.aspect == rhs.aspect
    }
}
