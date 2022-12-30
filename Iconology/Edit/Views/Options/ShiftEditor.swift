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
    
    var body: some View {
        Group {
            HStack {
                Text("Shift")
                    .font(.title2)
                    .padding(.top)
                Spacer()
            }
            
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
                    .dontRedraw()
                }
                
            }
        }
    }
}

extension ShiftEditor: Equatable {
    static func == (lhs: ShiftEditor, rhs: ShiftEditor) -> Bool {
        lhs.shift == rhs.shift
    }
}
