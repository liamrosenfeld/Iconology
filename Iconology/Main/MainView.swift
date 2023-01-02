//
//  MainView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @StateObject private var imageRetriever = ImageRetriever()

    var body: some View {
        NavigationStack {
            if imageRetriever.image != nil {
                EditView(imageRetriever: imageRetriever)
            } else {
                HomeView(imageRetriever: imageRetriever)
            }
        }
        .frame(minWidth: 750, minHeight: 750)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

