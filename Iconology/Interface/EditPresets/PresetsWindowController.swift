//
//  EditPresetsWindowController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/28/18.
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
        addPresetItems()
    }
    
    func windowDidResignMain(_ notification: Notification) {
        removePresetItems()
    }
    
    // MARK: - Menu Bar
    var vc: PresetViewController { contentViewController as! PresetViewController}
    var saveAction: Selector { #selector(vc.save) }
    var undoAction: Selector { #selector(vc.undo) }
    var redoAction: Selector { #selector(vc.redo) }
    
    let fileText = "File"
    let editText = "Edit"
    let undoText = "Undo"
    let redoText = "Redo"
    let saveText = "Save"
    
    func addPresetItems() {
        let save = NSMenuItem(title: saveText, action: saveAction, keyEquivalent: "s")
        fileMenu.insertItem(save, at: 0)
    }
    
    func removePresetItems() {
        fileMenu.removeItem(at: 0)
    }
    
    var fileMenu: NSMenu {
        let mainMenu = NSApplication.shared.mainMenu
        return mainMenu!.item(withTitle: fileText)!.submenu!
    }
    
    var editMenu: NSMenu {
        let mainMenu = NSApplication.shared.mainMenu
        return mainMenu!.item(withTitle: editText)!.submenu!
    }
    
    func allowUndo(_ on: Bool) {
        let undo = editMenu.item(withTitle: undoText)
        undo?.action = on ? undoAction : nil
    }
    
    func allowRedo(_ on: Bool) {
        let redo = editMenu.item(withTitle: redoText)
        redo?.action = on ? redoAction : nil
    }
    
}
