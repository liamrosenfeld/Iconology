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
        presetVC = contentViewController as? PresetViewController
    }

    // MARK: - Closing

    func windowShouldClose(_: NSWindow) -> Bool {
        if edited {
            askClose()
            return false
        }

        return true
    }

    func askClose() {
        // Create Alert
        let alert = NSAlert()
        alert.messageText = "Do you want to save your changes?"

        // Add Buttons
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Don't Save")

        // Present
        alert.beginSheetModal(for: window!) { selected in
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

    func windowDidBecomeMain(_: Notification) {
        addPresetItems()
    }

    func windowDidResignMain(_: Notification) {
        removePresetItems()
    }

    // MARK: - Menu Bar
    var presetVC: PresetViewController!
    var saveAction: Selector { #selector(presetVC.save) }
    var undoAction: Selector { #selector(presetVC.undo) }
    var redoAction: Selector { #selector(presetVC.redo) }

    let fileText = "File"
    let editText = "Edit"
    let undoText = "Undo"
    let redoText = "Redo"
    let saveText = "Save"
    let closeText = "Close"

    func addPresetItems() {
        let save = NSMenuItem(title: saveText, action: saveAction, keyEquivalent: "s")
        fileMenu.insertItem(save, at: 0)
        fileMenu.item(withTitle: closeText)?.action = #selector(window?.performClose(_:))
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

    func allowUndo(_ allowed: Bool) {
        let undo = editMenu.item(withTitle: undoText)
        undo?.action = allowed ? undoAction : nil
    }

    func allowRedo(_ allowed: Bool) {
        let redo = editMenu.item(withTitle: redoText)
        redo?.action = allowed ? redoAction : nil
    }
}
