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
        Window("Iconology", id: WindowID.main) {
            MainView()
                .environmentObject(customPresetStore)
                .focusedSceneValue(\.focusedWindow, WindowID.main)
        }.commands {
            CustomMenuCommands()
        }
        
        Window("Custom Presets Editor", id: WindowID.presetEditor) {
            CustomPresetsView()
                .environmentObject(customPresetStore)
                .focusedSceneValue(\.focusedWindow, WindowID.presetEditor)
        }
        
        Window("Settings", id: WindowID.settings) {
            EmptyView()
                .focusedSceneValue(\.focusedWindow, WindowID.settings)
        }
    }
}

enum WindowID {
    static let main = "image-editor"
    static let presetEditor = "custom-presets-editor"
    static let settings = "settings"
}

struct FocusedWindow: FocusedValueKey {
    typealias Value = String
}

extension FocusedValues {
    var focusedWindow: FocusedWindow.Value? {
        get { self[FocusedWindow.self] }
        set { self[FocusedWindow.self] = newValue }
    }
}
