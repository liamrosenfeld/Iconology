//
//  MainView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject private var imageMod = ImageModifier()

    var body: some View {
        Group {
            if imageMod.origImage != nil {
                EditView(modifier: imageMod)
            } else {
                DragView(image: $imageMod.origImage)
            }
        }.frame(minWidth: 350, minHeight: 350)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
