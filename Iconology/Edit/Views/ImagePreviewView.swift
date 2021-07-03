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
        VStack(alignment: .leading) {
            Text("Aspect: \(Int(aspect.width)):\(Int(aspect.height))")
                .font(.title2)
                .foregroundColor(Color.secondary)
            Image(decorative: image, scale: 1, orientation: .up)
                .resizable()
                .aspectRatio(aspect, contentMode: .fit)
                .background(
                    ZStack {
                        Color.white
                        Checkerboard(rows: 70, columns: 70)
                            .fill(Color(.sRGB, white: 0.88, opacity: 1))
                    }
                    
                )
        }
    }
}

struct Checkerboard: Shape {
    let rows: Int
    let columns: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // figure out how big each row/column needs to be
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0 ..< rows {
            for column in 0 ..< columns {
                // only add square where it should be colored
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)

                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }

        return path
    }
}
