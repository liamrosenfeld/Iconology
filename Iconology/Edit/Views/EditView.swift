//
//  EditView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var modifier: ImageModifier
    
    @State private var preset: Preset = defaultPresets[0].presets[0]
    @State private var editShown = false
    @State private var aspect = CGSize(width: 1, height: 1)

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .bottom) {
                if let image = modifier.finalImage {
                    ImagePreviewView(image: image, aspect: aspect)
                }
                Button {
                    editShown = true
                } label: {
                    Image(systemName: "pencil")
                }
                .accessibility(label: Text("Edit"))
                .dontRedraw()
                .popover(isPresented: $editShown, arrowEdge: .trailing) {
                    EditOptionsView(mods: modifier, aspect: aspect, enabled: preset.useModifications)
                        .frame(width: 275)
                        .padding()
                }
            }

            PresetPickerView(preset: $preset, size: $modifier.size, aspect: $aspect)
                .equatable()

            Spacer()
            
            HStack {
                Button("New Image", action: selectImage)
                Spacer()
                Button("Export", action: export)
            }.dontRedraw()
        }
        .padding(20)
        .onChange(of: modifier.size, perform: sizeChanged)
        .onAppear {
            modifier.observeChanges()
            sizeChanged(modifier.size)
        }
    }
    
    func sizeChanged(_ new: CGSize) {
        // if the selected size is too small for the image,
        // auto scale down the image so it fits
        guard let origSize = modifier.origImage?.size else { return }
        
        let widthScale = new.width / origSize.width
        let heightScale = new.height / origSize.height
        
        let minScale = min(widthScale, heightScale)
        if minScale < 1 {
            modifier.scale = max(minScale * 100, 10) // don't scale it beyond reason
            modifier.shift = .zero // bring it back to center
        }
    }
    
    func export() {
        // save
        // prompts for save location within function
        guard let savedTo = preset.save(modifier.finalImage!) else { return }

        // show user where it was saved
        // TODO: Preference to toggle this
        if savedTo.isFileURL {
            NSWorkspace.shared.activateFileViewerSelecting([savedTo])
        } else {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: savedTo.path)
        }
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
        self.modifier.origImage = image.cgImage
    }
}

struct EditView_Previews: PreviewProvider {
    @StateObject static var modifier = ImageModifier(image: NSImage(named: "Logo")!.cgImage)
    
    static var previews: some View {
        EditView(modifier: modifier)
            .colorScheme(.light)
        EditView(modifier: modifier)
            .colorScheme(.dark)
    }
}
