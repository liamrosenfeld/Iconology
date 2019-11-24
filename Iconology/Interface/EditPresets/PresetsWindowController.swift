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
    
    let editTag = 890850937668
    let undoTag = 879459854568
    let redoTag = 456789093562
    
    var vc: PresetViewController { contentViewController as! PresetViewController}
    var saveAction: Selector { #selector(vc.save) }
    var undoAction: Selector { #selector(vc.undo) }
    var redoAction: Selector { #selector(vc.redo) }
    
    func addEditMenu() {
        let mainMenu = NSApplication.shared.mainMenu
        mainMenu?.insertItem(editMenu, at: editIndex)
    }
    
    func removeEditMenu() {
        let mainMenu = NSApplication.shared.mainMenu
        mainMenu?.removeItem(at: editIndex)
    }
    
    var editMenu: NSMenuItem {
        // top level menu
        let editMenu = NSMenuItem(title: "Edit", action: nil, keyEquivalent: "")
        editMenu.submenu = NSMenu(title: "Edit")
        
        // menu items
        let items = [
            NSMenuItem(title: "Save", action: saveAction, keyEquivalent: "s"),
            .separator(),
            NSMenuItem(title: "Undo", action: undoAction, keyEquivalent: "z"),
            NSMenuItem(title: "Redo", action: redoAction, keyEquivalent: "Z"),
        ]

        // tags
        editMenu.tag = editTag
        items[2].tag = undoTag
        items[3].tag = redoTag
        
        // add
        items.forEach { editMenu.submenu?.addItem($0) }
        
        return editMenu
    }
    
    func allowUndo(_ on: Bool) {
        let mainMenu = NSApplication.shared.mainMenu
        let editMenu = mainMenu?.item(withTag: editTag)
        let undo = editMenu?.submenu?.item(withTag: undoTag)
        undo?.action = on ? undoAction : nil
    }
    
    func allowRedo(_ on: Bool) {
        let mainMenu = NSApplication.shared.mainMenu
        let editMenu = mainMenu?.item(withTag: editTag)
        let redo = editMenu?.submenu?.item(withTag: redoTag)
        redo?.action = on ? redoAction : nil
    }
    
}
