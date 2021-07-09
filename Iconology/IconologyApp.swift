//
//  Iconology.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

@main
struct Iconology: App {
    
    @StateObject private var customPresetStore = CustomPresetsStore()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(customPresetStore)
        }
        WindowGroup("Custom Presets Editor") {
            CustomPresetsView()
                .environmentObject(customPresetStore)
                .handlesExternalEvents(preferring: ["custom-presets-editor"], allowing: ["custom-presets-editor"]) // activate existing window if exists
        }
        .handlesExternalEvents(matching: ["custom-presets-editor"]) // create new window if one doesn't exist
    }
}
