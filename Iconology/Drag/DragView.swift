//
//  DragView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import AppKit

struct DragView: View {
    @Binding var image: CGImage?

    @State var imageUrl: URL?
    @State var isDropping = false

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
                Text(isDropping ?  "That Would Work!": "Drag Image Here")
                    .transaction { transaction in
                        // prevent the text from animating when changing
                        transaction.animation = nil
                    }
                Text("Or")
                    .padding(.top, 10)
                Button("Choose Image", action: selectImage)

                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(isDropping ? Color.gray.opacity(0.20) : Color.clear)
            .cornerRadius(18)
            .onDrop(of: [.fileURL], delegate: self)
        }
        .padding(35)
        .onChange(of: imageUrl, perform: imageFromUrl)
        .onReceive(
            NotificationCenter.default.publisher(for: .menuImageOpen),
            perform: { _ in selectImage() }
        )
    }

    func selectImage() {
        imageFromUrl(url: NSOpenPanel().selectImage())
    }

    func imageFromUrl(url: URL?) {
        guard let url = url else { return }
        guard let image = NSImage(contentsOf: url) else {
            // TODO: show error
            return
        }
        self.image = image.cgImage
    }
}

struct DragView_Previews: PreviewProvider {
    @State static private var image: CGImage?

    static var previews: some View {
        DragView(image: $image)
    }
}
