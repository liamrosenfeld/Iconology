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

    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        NavigationSplitView {
            CustomPresetSelector()
                .preventSidebarCollapse()
                .frame(minWidth: 225)
        } detail: {
            Group {
                if let selectedIndex = store.presetIndex, selectedIndex < store.presets.count {
                    CustomPresetEditor(preset: $store.presets[selectedIndex])
                } else {
                    Text(store.presets.count == 0
                         ? "Create a Preset to Edit"
                         : "Select a Preset to Edit"
                    )
                    .navigationTitle("")
                    .onAppear {
                        // send notif to disable menu items
                        NotificationCenter.default.post(Notification(name: .editPresetSelected, object: false))
                    }
                    .onDisappear {
                        // send notif to enable menu items
                        NotificationCenter.default.post(Notification(name: .editPresetSelected, object: true))
                    }
                }
            }.frame(minWidth: 300)
        }
        .frame(minWidth: 600, minHeight: 325)
        .onAppear {
            store.undoManager = undoManager
        }
        .onChange(of: undoManager) { manager in
            store.undoManager = manager
        }
    }
}

struct CustomPresetsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPresetsView()
    }
}
