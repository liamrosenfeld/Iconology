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
    
    @Environment(\.controlActiveState) var controlActiveState

    var body: some View {
        NavigationStack {
            if imageRetriever.image != nil {
                EditView(imageRetriever: imageRetriever)
            } else {
                HomeView(imageRetriever: imageRetriever)
            }
        }
        .frame(minWidth: 750, minHeight: 750)
        
        // notify if select image failure
        .alert("Unable to Use Image", isPresented: $imageRetriever.imageError) {
            Button("Ok") {
                imageRetriever.imageError = false
            }
        }
        
        // enable/disable the export menu item when window is focused
        .onChange(of: controlActiveState) { state in
            if state == .key {
                let hasImage = imageRetriever.image != nil
                NotificationCenter.default.post(Notification(name: .imageSelected, object: hasImage))
            }
        }
        
        // open new image menu button
        .onReceive(NotificationCenter.default.publisher(for: .menuImageOpen)) { _ in
            // only trigger if window focused
            if controlActiveState == .key {
                imageRetriever.selectImage()
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

