//
//  CustomPresetsView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/4/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomPresetsView: View {
    @EnvironmentObject var store: CustomPresetsStore
    @State private var selection: Preset.ID?
    
    var body: some View {
        NavigationView {
            CustomPresetSelector(selection: $selection)
            if store.presets.count == 0 {
                Text("Create a Preset to Edit")
                    .navigationTitle("")
            } else if let selection = selection {
                CustomPresetEditor(presetSelection: selection)
            } else {
                Text("Select a Preset to Edit")
                    .navigationTitle("")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Label("Toggle Sidebar", systemImage: "sidebar.leading")
                })
            }
        }
    }
    
    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct CustomPresetsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPresetsView()
    }
}
