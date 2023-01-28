//
//  SettingsView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/28/23.
//  Copyright © 2023 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

enum SettingsKeys {
    static let openOnSave = "OpenOnSave"
}

struct SettingsView: View {
    @AppStorage(SettingsKeys.openOnSave) private var openOnSave = true
    
    @EnvironmentObject var store: CustomPresetsStore
    
    @State private var resetAlert = false
    
    var body: some View {
        Form {
            Toggle("Open Save Location", isOn: $openOnSave)
            Button("Reset Custom Presets") { resetAlert = true }
        }
        .formStyle(.grouped)
        .alert(
            "Delete All Custom Presets?",
            isPresented: $resetAlert,
            actions: {
                Button("Cancel", role: .cancel, action: { resetAlert = false })
                Button("Delete", role: .destructive, action: store.reset)
            }, message: {
                Text("This cannot be reversed")
            }
        )
        .frame(width: 350, height: 300)
    }
}
