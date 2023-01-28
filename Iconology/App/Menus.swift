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
    
    // if the current editor window has an image
    let imageSelectedPub = NotificationCenter.default.publisher(for: .imageSelected)
    @State private var imageSelected = false
    
    // if there is a preset selected (default to true because the none selected view sends the notif)
    let editPresetSelectedPub = NotificationCenter.default.publisher(for: .editPresetSelected)
    @State private var editPresetSelected = true
    
    // handled by the menu so it is always listening
    let openMainWindowPub = NotificationCenter.default.publisher(for: .openMainWindow)
    
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
        
        
        CommandGroup(replacing: .newItem) {
            // Add open/export (depending on the focused window)
            if focusedWindow == WindowID.main {
                Button("Open Image…") {
                    NotificationCenter.default.post(Notification(name: .menuImageOpen))
                }
                .keyboardShortcut(KeyboardShortcut("o"))
                
                Button("Export…") {
                    NotificationCenter.default.post(Notification(name: .menuImageExport))
                }
                .keyboardShortcut(KeyboardShortcut("e"))
                .disabled(!imageSelected)
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
            
            Divider()
            
            // always allow opening a new editor
            Button("New Editor Window") {
                openWindow(id: WindowID.main)
            }
            .keyboardShortcut(KeyboardShortcut("n", modifiers: [.command, .option]))
        }
        
        // Sending feedback in help
        CommandGroup(before: .help) {
            Button("Send Feedback") {
                openURL(URL(string: "https://github.com/liamrosenfeld/Iconology/issues")!)
            }
            
            // stick the notification listening here so it always listens
            .onReceive(imageSelectedPub) { notif in
                imageSelected = notif.object as? Bool ?? false
            }
            .onReceive(editPresetSelectedPub) { notif in
                editPresetSelected = notif.object as? Bool ?? false
            }
            .onReceive(openMainWindowPub) { _ in
                openWindow(id: WindowID.main)
            }
        }
    }
}

extension Notification.Name {
    // app -> menu
    static let imageSelected      = Notification.Name(rawValue: "Menu_Image_Selected")
    static let editPresetSelected = Notification.Name(rawValue: "Menu_Preset_Selected")
    
    // menu -> app
    static let menuImageOpen     = Notification.Name(rawValue: "Menu_Image_Open")
    static let menuImageExport   = Notification.Name(rawValue: "Menu_Image_Export")
    
    static let menuPresetNew     = Notification.Name(rawValue: "Menu_Preset_New")
    static let menuPresetNewSize = Notification.Name(rawValue: "Menu_Preset_NewSize")
    static let menuPresetImport  = Notification.Name(rawValue: "Menu_Preset_Import")
    static let menuPresetExport  = Notification.Name(rawValue: "Menu_Preset_Export")
    
    // app delegate -> menu
    static let openMainWindow    = Notification.Name(rawValue: "AppDelegate_Open_Main_Window")
}
