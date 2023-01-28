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
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var customPresetStore = CustomPresetsStore()
    
    var body: some Scene {
        WindowGroup("Iconology", id: WindowID.main) {
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
            SettingsView()
                .environmentObject(customPresetStore)
                .focusedSceneValue(\.focusedWindow, WindowID.settings)
        }
        .windowResizability(.contentSize)
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

class AppDelegate: NSObject, NSApplicationDelegate {
    // when dock icon pressed,
    // open new main window if there is not already one
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let mainOpen = NSApp.windows.first(where: { window in
            // identifier for window group in form "[id]-AppWindow-[num]"
            (window.identifier?.rawValue.hasPrefix(WindowID.main) ?? false) && window.isVisible
        }) != nil
        
        if !mainOpen {
            // this is handled by Menus so it always listens
            NotificationCenter.default.post(Notification(name: .openMainWindow))
        }
        
        return true
    }
}

