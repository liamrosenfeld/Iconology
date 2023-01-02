//
//  ImagePreviewView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/9/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct ImagePreviewView: View {
    var image: CGImage
    var aspect: CGSize

    var body: some View {
        Image(decorative: image, scale: 1, orientation: .up)
            .resizable()
            .aspectRatio(aspect, contentMode: .fit)
            .background(
                CheckerboardView()
            )
    }
}

struct CheckerboardView: View {
    let rows = 70
    let cols = 70
    
    let color = Color(.sRGB, white: 0.88, opacity: 1)
    
    var body: some View {
        // uses Canvas instead of Shape because Canvas updates less often (in my testing)
        Canvas { context, size in
            // color the background white
            let entire = Path(CGRect(origin: .zero, size: size))
            context.fill(entire, with: .color(.white))

            // figure out how big each rect needs to be
            let rowSize = size.height / CGFloat(rows)
            let colSize = size.width / CGFloat(cols)

            // loop over all rows and columns, making alternating squares colored
            for row in 0 ..< rows {
                for col in 0 ..< cols {
                    // only add square where it should be colored
                    if (row + col).isMultiple(of: 2) {
                        let startX = colSize * CGFloat(col)
                        let startY = rowSize * CGFloat(row)

                        let rect = Path(CGRect(x: startX, y: startY, width: colSize, height: rowSize))
                        context.fill(rect, with: .color(color))
                    }
                }
            }
        }
    }
}
