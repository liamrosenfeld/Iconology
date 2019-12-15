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
}
