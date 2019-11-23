//
//  EditPresetsWindowController.swift
//  Iconology
//
//  Created by Liam on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PresetsWindowController: NSWindowController, NSWindowDelegate {
    
    var edited = false {
        didSet {
            self.setDocumentEdited(edited)
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    // MARK: - Closing
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if self.edited {
            askClose()
            return false
        }
        
        return true
    }
    
    func askClose(){
        // Create Alert
        let alert = NSAlert()
        alert.messageText = "Do you want to save your changes?"
        
        // Add Buttons
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Don't Save")
        
        // Present
        alert.beginSheetModal(for: self.window!) { selected in
            if selected == .alertFirstButtonReturn {
                // save
                let controller = self.window?.contentViewController
                controller?.commitEditing() // sets edited to false
                self.close()
            } else if selected == .alertSecondButtonReturn {
                // cancel
                return
            } else if selected == .alertThirdButtonReturn {
                // don't save
                let controller = self.window?.contentViewController
                controller?.discardEditing() // sets edited to false
                self.close()
            }
        }
    }
    
    // MARK: - In Front
    func windowDidBecomeMain(_ notification: Notification) {
        addEditMenu()
    }
    
    func windowDidResignMain(_ notification: Notification) {
        removeEditMenu()
    }
    
    // MARK: - Menu Bar
    let editIndex = 1
    
    func addEditMenu() {
        let mainMenu = NSApplication.shared.mainMenu
        mainMenu?.insertItem(editMenu, at: editIndex)
    }
    
    func removeEditMenu() {
        let mainMenu = NSApplication.shared.mainMenu
        mainMenu?.removeItem(at: editIndex)
    }
    
    var editMenu: NSMenuItem {
        let vc = self.contentViewController as? PresetViewController
        
        let editMenu = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        editMenu.submenu = NSMenu(title: "Edit")

        editMenu.submenu?.addItem(NSMenuItem(title: "Save", action: #selector(vc?.save), keyEquivalent: "s"))
        
        return editMenu
    }
    
}
