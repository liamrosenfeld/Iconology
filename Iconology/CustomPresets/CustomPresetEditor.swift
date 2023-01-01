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
    
    @State private var sizeSelection: ImgSetSize.ID?
    @State private var aspectShown = false
    
    var body: some View {
        Table($preset.sizes, selection: $sizeSelection) {
            TableColumn("Name") { $imgSize in
                TextField("Name", text: $imgSize.name)
            }
            
            TableColumn("Width") { $imgSize in
                TextField("Width", value: $imgSize.size.width, formatter: .floatFormatter)
            }
            
            TableColumn("Height") { $imgSize in
                TextField("Height", value: $imgSize.size.height, formatter: .floatFormatter)
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
                Button(action: addSize) {
                    Label("Add Size", systemImage: "plus")
                }
                Button(action: removeSize) {
                    Label("Remove Size", systemImage: "minus")
                }
            }
        }
        .navigationTitle("\(preset.name)'s Sizes")
        .onReceive(
            NotificationCenter.default.publisher(for: .menuPresetNewSize),
            perform: { _ in addSize()}
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
                TextField("Horizontal", value: $preset.aspect.width, formatter: Formatter.intFormatter)
                Text(":")
                TextField("Vertical", value:  $preset.aspect.height, formatter: Formatter.intFormatter)
            }
        }.padding()
    }
    
    // MARK: - Actions
    func addSize() {
        var n = 1
        while preset.sizes.contains(where: { $0.name == "Size \(n)" }) {
            n += 1
        }
        preset.sizes.append(ImgSetSize(name: "Size \(n)", size: .unit))
    }
    
    func removeSize() {
        // do not allow to delete the last size
        if preset.sizes.count == 1 {
            return
        }
        
        // delete
        guard let sizeSelection = sizeSelection else {
            return
        }
        let sizeIndex = preset.sizes.indexWithId(sizeSelection)
        preset.sizes.remove(at: sizeIndex)
        
        // adapt selection
        self.sizeSelection = preset.sizes[max(sizeIndex - 1, 0)].id
    }
    
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
