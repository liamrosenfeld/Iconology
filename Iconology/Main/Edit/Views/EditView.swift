//
//  EditView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var imageRetriever: ImageRetriever
    @StateObject private var modifier = ImageModifier()
    @StateObject private var presetSelection = PresetSelection()
    
    @State private var editShown = false
    @State private var isDropping = false

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            HStack(alignment: .bottom) {
                if let image = modifier.finalImage {
                    ImagePreviewView(image: image, aspect: presetSelection.aspect)
                        .opacity(imageRetriever.isDropping ? 0.5 : 1)
                        .onDrop(of: ImageRetriever.dragTypes, delegate: imageRetriever)
                }
                Button {
                    editShown = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibility(label: Text("Edit"))
                .dontRedraw()
                .popover(isPresented: $editShown, arrowEdge: .trailing) {
                    EditOptionsView(
                        mods: modifier,
                        aspect: presetSelection.aspect,
                        enabled: presetSelection.preset.enabledModifications
                    )
                        .frame(width: 275)
                        .padding()
                }
            }
            
            Spacer()

            PresetPickerView(selection: presetSelection)
                .padding(.bottom, 10)
            
            HStack {
                Button("New Image", action: imageRetriever.selectImage)
                Spacer()
                Button("Export", action: export)
            }.dontRedraw()
        }
        .padding(20)
        
        // respond to preset change
        .onChange(of: presetSelection.size, perform: { newSize in
            modifier.size = newSize
            modifier.scaleToFit()
        })
        
        // set up modifier
        .onAppear {
            // set up modifier
            modifier.origImage = imageRetriever.image
            modifier.observeChanges()
            modifier.size = presetSelection.size
            modifier.scaleToFit()
            
            // enable menu bar buttons for image editing
            NotificationCenter.default.post(Notification(name: .imageProvided))
        }
        .onChange(of: imageRetriever.image) { newImage in
            modifier.origImage = newImage
            modifier.scaleToFit()
        }
        
        // menu notifications
        .onReceive(
            NotificationCenter.default.publisher(for: .menuImageOpen),
            perform: { _ in imageRetriever.selectImage() }
        )
        .onReceive(
            NotificationCenter.default.publisher(for: .menuImageExport),
            perform: { _ in export() }
        )
    }
    
    func export() {
        // save
        // prompts for save location within function
        guard let savedTo = presetSelection.preset.save(modifier.finalImage!) else { return }

        // show user where it was saved
        // TODO: Preference to toggle this
        if savedTo.isFileURL {
            NSWorkspace.shared.activateFileViewerSelecting([savedTo])
        } else {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: savedTo.path)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    @StateObject static var retriever = ImageRetriever(image: NSImage(named: "Logo")!.cgImage)
    
    static var previews: some View {
        EditView(imageRetriever: retriever)
            .colorScheme(.light)
        EditView(imageRetriever: retriever)
            .colorScheme(.dark)
    }
}
