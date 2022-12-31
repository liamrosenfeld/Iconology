//
//  Menus.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/30/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

struct CustomMenuCommands: Commands {
    @Environment(\.openURL) var openURL
    @Environment(\.openWindow) var openWindow
    
    @FocusedValue(\.focusedWindow) var focusedWindow
    
    // image can only be provided once so it can just be toggled once
    let imageProvidedPub = NotificationCenter.default.publisher(for: .imageProvided)
    @State private var imageWasProvided = false
    
    // if there is a preset selected (default to true because the none selected view sends the notif)
    let editPresetSelectedPub = NotificationCenter.default.publisher(for: .editPresetSelected)
    @State private var editPresetSelected = true
    
    var body: some Commands {
        // Add opening settings to Iconology Tab
        CommandGroup(after: .appSettings) {
            Button("Settings…") {
                openWindow(id: WindowID.settings)
            }
            .keyboardShortcut(KeyboardShortcut(","))
            
            Button("Custom Presets Editor…") {
                openWindow(id: WindowID.presetEditor)
            }
            .keyboardShortcut(KeyboardShortcut(",", modifiers: [.command, .shift]))
        }
        
        // Add open/saving to file (depending on the focused window)
        CommandGroup(replacing: .newItem) {
            if focusedWindow == WindowID.main {
                Button("Open Image…") {
                    NotificationCenter.default.post(Notification(name: .menuImageOpen))
                }
                .keyboardShortcut(KeyboardShortcut("o"))
                
                Button("Export…") {
                    NotificationCenter.default.post(Notification(name: .menuImageExport))
                }
                .keyboardShortcut(KeyboardShortcut("e"))
                .disabled(!imageWasProvided)
            } else if focusedWindow == WindowID.presetEditor {
                Button("New Preset") {
                    NotificationCenter.default.post(Notification(name: .menuPresetNew))
                }
                .keyboardShortcut(KeyboardShortcut("n", modifiers: [.command, .shift]))
                
                
                Button("Import Preset…") {
                    NotificationCenter.default.post(Notification(name: .menuPresetImport))
                }
                .keyboardShortcut(KeyboardShortcut("i"))
                
                Divider()
                
                Button("New Size") {
                    NotificationCenter.default.post(Notification(name: .menuPresetNewSize))
                }
                .keyboardShortcut(KeyboardShortcut("n"))
                .disabled(!editPresetSelected)
                
                Button("Export Preset…") {
                    NotificationCenter.default.post(Notification(name: .menuPresetExport))
                }
                .keyboardShortcut(KeyboardShortcut("e"))
                .disabled(!editPresetSelected)
            }
        }
        
        // Sending feedback in help
        CommandGroup(before: .help) {
            Button("Send Feedback") {
                openURL(URL(string: "https://github.com/liamrosenfeld/Iconology/issues")!)
            }
            
            // stick the notification listening here so it always listens
            .onReceive(imageProvidedPub) { _ in
                imageWasProvided = true
            }
            .onReceive(editPresetSelectedPub) { notif in
                editPresetSelected = notif.object as? Bool ?? false
            }
        }
    }
}

extension Notification.Name {
    // app -> menu
    static let imageProvided      = Notification.Name(rawValue: "Menu_Image_Provided")
    static let editPresetSelected = Notification.Name(rawValue: "Menu_Preset_Selected")
    
    // menu -> app
    static let menuImageOpen     = Notification.Name(rawValue: "Menu_Image_Open")
    static let menuImageExport   = Notification.Name(rawValue: "Menu_Image_Export")
    
    static let menuPresetNew     = Notification.Name(rawValue: "Menu_Preset_New")
    static let menuPresetNewSize = Notification.Name(rawValue: "Menu_Preset_NewSize")
    static let menuPresetImport  = Notification.Name(rawValue: "Menu_Preset_Import")
    static let menuPresetExport  = Notification.Name(rawValue: "Menu_Preset_Export")
}
