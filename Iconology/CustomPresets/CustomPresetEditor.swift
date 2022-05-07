//
//  CustomPresetEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/5/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetEditor: View {
    @EnvironmentObject var store: CustomPresetsStore
    var presetSelection: Preset.ID
    
    @State private var sizeSelection: ImgSetSize.ID?
    @State private var aspectShown = false
    @State private var presetIndex: Int?
    
    var body: some View {
        table
            .toolbar {
                ToolbarItemGroup {
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
            .navigationTitle(name)
            .onAppear {
                presetIndex = store.presets.firstIndex { $0.id == presetSelection }
            }
            .onChange(of: presetSelection) { newValue in
                presetIndex = store.presets.firstIndex { $0.id == newValue }
            }
    }
    
    var name: String {
        guard let presetIndex = presetIndex, store.presets.count > 0 else {
            return "Sizes"
        }
        return "\(store.presets[presetIndex].name)'s Sizes"
    }
    
    func aspectEditor() -> some View {
        return VStack {
            Text("Aspect Ratio")
            HStack {
                TextField("Horizontal", value: $store.presets[presetIndex!].aspect.width, formatter: Formatter.intFormatter)
                Text(":")
                TextField("Vertical", value:  $store.presets[presetIndex!].aspect.height, formatter: Formatter.intFormatter)
            }
        }.padding()
    }
    
    // MARK: - Table
    var table: some View {
        return Table(imgSizes, selection: $sizeSelection) {
            TableColumn("Name") { imgSize in
                TextField("Name", text: imgSetSizeBinding(id: imgSize.id).name)
            }
            
            TableColumn("Width") { imgSize in
                TextField("Width", value: imgSetSizeBinding(id: imgSize.id).size.width, formatter: .floatFormatter)
            }
            
            TableColumn("Height") { imgSize in
                TextField("Width", value: imgSetSizeBinding(id: imgSize.id).size.height, formatter: .floatFormatter)
            }
        }
    }
    
    func imgSetSizeBinding(id: ImgSetSize.ID) -> Binding<ImgSetSize> {
        guard let presetIndex = presetIndex else {
            return Binding.constant(ImgSetSize.init(name: "filler", size: .zero))
        }
        return $store.presets[presetIndex].type.imgSizes[imgSizes.indexWithId(id)]
    }
    
    var imgSizes: [ImgSetSize] {
        guard let presetIndex = presetIndex, store.presets.count > 0 else { return [] }
        return store.presets[presetIndex].type.imgSizes
    }
    
    // MARK: - Actions
    func addSize() {
        guard let presetIndex = presetIndex else { return }
        var n = 1
        while true {
            if !imgSizes.contains(where: { $0.name == "New Size \(n)" }) {
                break
            }
            n += 1
        }
        store.presets[presetIndex].type.imgSizes.append(ImgSetSize(name: "New Size \(n)", w: 1, h: 1))
    }
    
    func removeSize() {
        // delete
        guard let sizeSelection = sizeSelection, let presetIndex = presetIndex else {
            return
        }
        let sizeIndex = imgSizes.indexWithId(sizeSelection)
        store.presets[presetIndex].type.imgSizes.remove(at: sizeIndex)
        
        // adapt selection
        if imgSizes.count > 0 {
            self.sizeSelection = imgSizes[max(sizeIndex - 1, 0)].id
        } else {
            self.sizeSelection = nil
        }
    }
}
