//
//  EditView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @StateObject var modifier: ImageModifier
    
    @State private var preset: Preset = defaultPresets.first!.presets.first!
    @State private var prefix = ""
    
    @State private var editShown = false

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .bottom) {
                ImagePreviewView(image: modifier.finalImage!, aspect: modifier.mods.aspect)
                Button {
                    editShown = true
                } label: {
                    Image(systemName: "pencil")
                }.accessibility(label: Text("Edit"))
                .popover(isPresented: $editShown, arrowEdge: .trailing) {
                    EditOptionsView(mods: modifier.mods, enabled: preset.useModifications)
                        .frame(width: 275)
                        .padding()
                }
            }

            PresetPickerView(preset: $preset)
                .frame(maxWidth: 200)
            Button("Edit Custom Presets", action: {})

            Spacer()
            
            HStack {
                Button("New Image", action: selectImage)
                Spacer()
                Button("Export", action: export)
            }
        }
        .padding(20)
        .onChange(of: preset) { modifier.mods.aspect = $0.aspect }
        .onAppear(perform: modifier.observeChanges)
    }

    func export() {
        // prompt for save location
        // TODO: save file instead of select folder if a file preset
        let folder = NSOpenPanel().selectSaveFolder()
        guard let chosenFolder = folder else { return }

        // save
        let savedTo = preset.save(modifier.finalImage!, at: chosenFolder, with: prefix)

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
