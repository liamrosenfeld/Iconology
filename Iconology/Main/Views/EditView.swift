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
    
    @State private var adjustmentsShown = true
    @State private var isDropping = false
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.controlActiveState) var controlActiveState

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .center) {
                PresetPickerView(selection: presetSelection)
                    .padding(.top, 10)
                
                Spacer()
                
                if let image = modifier.finalImage {
                    ImagePreviewView(image: image, aspect: presetSelection.aspect)
                        .opacity(imageRetriever.isDropping ? 0.5 : 1)
                        .onDrop(of: ImageRetriever.dragTypes, delegate: imageRetriever)
                        .padding()
                }
                
                Spacer()
                
                Button("Export", action: export)
                    .padding(.bottom, 10)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background { Color("GeneratorBg") }
            
            if adjustmentsShown {
                EditOptionsView(
                    mods: modifier,
                    aspect: presetSelection.aspect,
                    enabled: presetSelection.preset.enabledMods,
                    defaultMods: presetSelection.preset.defaultMods
                )
                .padding()
                .frame(width: 275)
                .background { Color("InspectorBg") }
                .padding(.leading, 1)
                .background { Color("Divider") }
                .transition(.move(edge: .trailing))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        // respond to preset change
        .onChange(of: presetSelection.size) { newSize in
            modifier.size = newSize
            modifier.scaleToFit()
        }
        .onReceive(presetSelection.$preset) { newPreset in
            modifier.applyDefaults(newPreset.defaultMods)
        }
        
        // set up modifier
        .onAppear {
            // set up modifier
            modifier.origImage = imageRetriever.image
            modifier.observeChanges()
            
            // apply initial preset properties
            modifier.size = presetSelection.size
            modifier.scaleToFit()
            modifier.applyDefaults(presetSelection.preset.defaultMods)
            
            // enable menu bar buttons for image editing
            NotificationCenter.default.post(Notification(name: .imageSelected, object: true))
        }
        .onChange(of: imageRetriever.image) { newImage in
            modifier.origImage = newImage
            modifier.scaleToFit()
        }
        
        // export menu button
        .onReceive(NotificationCenter.default.publisher(for: .menuImageExport)) { _ in
            // only trigger if window focused
            if controlActiveState == .key {
                export()
            }
        }
        
        .toolbar {
            Button(action: { openWindow(id: WindowID.presetEditor) }) {
                Label("Edit Custom Presets", systemImage: "folder.fill.badge.person.crop")
                    .help("Edit Custom Presets")
            }
            
            Button(action: imageRetriever.selectImage) {
                Label("New Image", systemImage: "photo.on.rectangle.angled")
                    .help("New Image")
            }
            
            Button(action: {
                withAnimation {
                    adjustmentsShown.toggle()
                }
            }) {
                Label("Toggle Adjustments Panel", systemImage: "sidebar.right")
                    .help("Toggle Adjustments Panel")
            }
        }
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
    @StateObject static var customPresetStore = CustomPresetsStore()
    
    static var previews: some View {
        EditView(imageRetriever: retriever)
            .colorScheme(.light)
            .environmentObject(customPresetStore)
        EditView(imageRetriever: retriever)
            .colorScheme(.dark)
            .environmentObject(customPresetStore)
    }
}
