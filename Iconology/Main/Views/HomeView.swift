//
//  HomeView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import AppKit

struct HomeView: View {
    
    @ObservedObject var imageRetriever: ImageRetriever

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300, minHeight: 60)
                .padding(.horizontal, 50)
            Divider()
                .padding(.vertical, 10)
            VStack {
                Spacer()
                Image(systemName: "photo.on.rectangle.angled")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200, minHeight: 50)
                Text(imageRetriever.isDropping ?  "That Would Work!": "Drag Image Here")
                    .transaction { transaction in
                        // prevent the text from animating when changing
                        transaction.animation = nil
                    }
                Text("Or")
                    .padding(.top, 10)
                Button("Choose Image", action: imageRetriever.selectImage)

                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(imageRetriever.isDropping ? Color.gray.opacity(0.20) : Color.clear)
            .cornerRadius(18)
            .onDrop(of: ImageRetriever.dragTypes, delegate: imageRetriever)
        }
        .padding(35)
    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject static var imageRetriever = ImageRetriever()

    static var previews: some View {
        HomeView(imageRetriever: imageRetriever)
    }
}
