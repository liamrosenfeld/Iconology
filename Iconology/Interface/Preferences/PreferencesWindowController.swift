//
//  PreferencesWindowController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Hide window instead of closing
        window?.orderOut(sender)
        return false
    }

    // MARK: - Menu Items
    let fileText = "File"
    let closeText = "Close"

    func windowDidBecomeMain(_ notification: Notification) {
        fileMenu.item(withTitle: closeText)?.action = #selector(window?.performClose(_:))
    }

    var fileMenu: NSMenu {
        let mainMenu = NSApplication.shared.mainMenu
        return mainMenu!.item(withTitle: fileText)!.submenu!
    }
}
