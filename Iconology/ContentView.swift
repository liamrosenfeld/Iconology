//
//  ContentView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var image: NSImage?

    var body: some View {
        Group {
            if image != nil {
                EditView(image: image!)
                    .frame(minWidth: 800, minHeight: 800)
            } else {
                DragView(image: $image)
                    .frame(minWidth: 350, minHeight: 350)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
