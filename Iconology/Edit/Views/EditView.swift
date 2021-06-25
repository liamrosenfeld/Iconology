//
//  EditView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct EditView: View {
    @State var preset: Preset = defaultPresets.first!.presets.first!
    @StateObject var modifier: ImageModifier

    @State var prefix = ""

    init(image: CGImage) {
        self._modifier = StateObject(wrappedValue: ImageModifier(image: image))
    }

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Preset")
                    .font(.title)
                    .padding(.top, 10)
                PresetPickerView(preset: $preset)
                    .frame(maxWidth: 200)
                Button("Edit Custom Presets", action: {})
            }

            Group {
                Text("Edit")
                    .font(.title)
                    .padding(.top, 10)
                HStack {
                    ImagePreviewView(image: modifier.finalImage, aspect: modifier.mods.aspect)
                    EditOptionsView(mods: modifier.mods, enabled: preset.useModifications)
                        .frame(maxWidth: 300)
                        .padding(.horizontal)
                }
            }

            Group {
                Text("Export")
                    .font(.title)
                    .padding(.top, 10)
                HStack {
                    TextField("File Prefix", text: $prefix)
                        .frame(maxWidth: 200)
                    Button("Export", action: export)
                }
            }
            
            Button("New Image", action: selectImage)
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
        let savedTo = preset.save(modifier.finalImage, at: chosenFolder, with: prefix)

        // show user where it was saved
        // TODO: Preference to toggle this
        if savedTo.isFileURL {
            NSWorkspace.shared.activateFileViewerSelecting([savedTo])
        } else {
            print("here")
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
    static var previews: some View {
        EditView(image: NSImage(named: "Logo")!.cgImage)
            .colorScheme(.light)
        EditView(image: NSImage(named: "Logo")!.cgImage)
            .colorScheme(.dark)
    }
}
