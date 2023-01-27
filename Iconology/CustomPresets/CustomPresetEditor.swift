//
//  CustomPresetEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/5/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetEditor: View {
    @Binding var preset: ImgSetPreset
    
    @State private var aspectShown = false
    
    @EnvironmentObject var store: CustomPresetsStore
    
    var body: some View {
        Table($preset.sizes, selection: $store.sizeSelection) {
            TableColumn("Name") { $imgSize in
                OnCommitTextField(
                    "Name",
                    text: $imgSize.name,
                    onCommit: { (old, new) in
                        guard let sizeSelection = store.sizeSelection else { return }
                        store.registerSizeNameUndo(preset: preset.id, size: sizeSelection, old: old, new: new)
                    }
                )
            }
            
            TableColumn("Width") { $imgSize in
                OnCommitTextField(
                    "Width",
                    num: $imgSize.size.width,
                    onCommit: { (old, new) in widthUpdated(old: old, new: new) }
                )
            }
            
            TableColumn("Height") { $imgSize in
                OnCommitTextField(
                    "Height",
                    num: $imgSize.size.height,
                    onCommit: { (old, new) in heightUpdated(old: old, new: new) }
                )
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: exportPreset) {
                    Label("Export Preset", systemImage: "square.and.arrow.up")
                }
                Button {
                    aspectShown = true
                } label: {
                    Label("Edit Aspect Ratio", systemImage: "aspectratio")
                }
                .popover(isPresented: $aspectShown, arrowEdge: .bottom, content: aspectEditor)
            }
            ToolbarItemGroup {
                Button(action: store.addSize) {
                    Label("Add Size", systemImage: "plus")
                }
                Button(action: store.removeSize) {
                    Label("Remove Size", systemImage: "minus")
                }
                .disabled(preset.sizes.count == 1 || store.sizeSelection == nil)
            }
        }
        .navigationTitle("\(preset.name)'s Sizes")
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetNewSize),
            perform: { _ in store.addSize()}
        )
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetExport),
            perform: { _ in exportPreset()}
        )
    }
    
    func aspectEditor() -> some View {
        return VStack {
            Text("Aspect Ratio")
            HStack {
                OnCommitTextField(
                    "Horizontal",
                    num: $preset.aspect.width,
                    onCommit: { (old, new) in aspectWidthUpdated(old: old, new: new) }
                )
                Text(":")
                OnCommitTextField(
                    "Vertical",
                    num: $preset.aspect.height,
                    onCommit: { (old, new) in aspectHeightUpdated(old: old, new: new) }
                )
            }
        }.padding()
    }
    
    // MARK: - Aspect Enforcement
    func widthUpdated(old oldWidth: CGFloat, new newWidth: CGFloat) {
        guard let sizeSelection = store.sizeSelection,
              let index = preset.sizes.indexWithId(sizeSelection) else { return }
        
        // adjust height to preserve aspect
        let aspect = preset.aspect
        let oldHeight = preset.sizes[index].size.height
        let newHeight = ((newWidth / aspect.width) * aspect.height).rounded()
        preset.sizes[index].size.height = newHeight
        
        // register undo
        let old = CGSize(width: oldWidth, height: oldHeight)
        let new = CGSize(width: newWidth, height: newHeight)
        store.registerSizeDimUndo(preset: preset.id, size: sizeSelection, old: old, new: new)
    }
    
    func heightUpdated(old oldHeight: CGFloat, new newHeight: CGFloat) {
        guard let sizeSelection = store.sizeSelection,
              let index = preset.sizes.indexWithId(sizeSelection) else { return }
        
        // adjust width to preserve aspect
        let aspect = preset.aspect
        let oldWidth = preset.sizes[index].size.width
        let newWidth = ((newHeight / aspect.height) * aspect.width).rounded()
        preset.sizes[index].size.width = newWidth
        
        // register undo
        let old = CGSize(width: oldWidth, height: oldHeight)
        let new = CGSize(width: newWidth, height: newHeight)
        store.registerSizeDimUndo(preset: preset.id, size: sizeSelection, old: old, new: new)
    }
    
    func aspectWidthUpdated(old: CGFloat, new: CGFloat) {
        // update sizes to new aspect
        // locks the other dimension so that updating feels more natural
        preset.applyAspectKeepHeight()
        
        // register undo
        store.registerAspectWidthUndo(preset: preset.id, old: old, new: new)
    }
    
    func aspectHeightUpdated(old: CGFloat, new: CGFloat) {
        // update sizes to new aspect
        preset.applyAspectKeepWidth()
        
        // register undo
        store.registerAspectHeightUndo(preset: preset.id, old: old, new: new)
    }
    
    // MARK: - Actions
    func exportPreset() {
        guard let url = NSSavePanel().savePreset() else { return }
        guard let data = try? JSONEncoder().encode(preset) else { return }
        
        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
}

fileprivate extension NSSavePanel {
    func savePreset() -> URL? {
        self.title = "Save Your Preset File"
        self.allowedContentTypes = [.json]
        self.isExtensionHidden = false
        self.runModal()
        return self.url
    }
}
