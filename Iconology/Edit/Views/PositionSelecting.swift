//
//  PositionSelecting.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/9/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct PositionSelector: View {
    // both x and y in [-100, 100]
    @Binding var position: CGPoint

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Color.white
                    .cornerRadius(5)
                Color.accentColor
                    .frame(width: geometry.size.width / 15, height: geometry.size.width / 15)
                    .mask(Circle())
                    .offset(
                        x: position.x * (geometry.size.width / 2) / 100,
                        y: position.y * (geometry.size.height / 2) / -100
                    )
                    .gesture(drag)
            }
        }
    }

    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if abs(gesture.location.x) <= 100 {
                    self.position.x = gesture.location.x
                }
                if abs(gesture.location.y) <= 100 {
                    self.position.y = -gesture.location.y
                }
            }
    }
}

struct PositionInput: View {
    @Binding var position: CGPoint

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("X:")
                TextField("X Position", value: $position.x, formatter: NumberFormatter())
                    .frame(width: 50)
                Text("%")
            }
            HStack {
                Text("Y:")
                TextField("Y Position", value: $position.y, formatter: NumberFormatter())
                    .frame(width: 50)
                Text("%")
            }
        }
    }
}

struct PositionSelector_Previews: PreviewProvider {
    @State static var position: CGPoint = .zero

    static var previews: some View {
        PositionSelector(position: $position)
            .frame(width: 200, height: 200)
    }
}
