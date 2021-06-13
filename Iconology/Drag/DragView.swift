//
//  ContentView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import AppKit

struct DragView: View {
    @Binding var image: NSImage?

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
                Text("Or")
                    .padding(.top, 10)
                Button("Choose Image", action: selectImage)

                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(isDropping ? Color.gray.opacity(0.25) : Color.clear)
            .cornerRadius(18)
            .onDrop(of: [.fileURL], delegate: self)
        }
        .padding(35)
        .onChange(of: imageUrl, perform: imageFromUrl)
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
        self.image = image
    }
}

struct DragView_Previews: PreviewProvider {
    @State static private var image: NSImage?

    static var previews: some View {
        DragView(image: $image)
    }
}
