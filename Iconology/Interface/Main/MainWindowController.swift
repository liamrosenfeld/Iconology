//
//  MainWindowController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/20/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    // MARK: - Presenting

    var drag: DragViewController?
    var options: OptionsViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        drag = instantiateVC(withID: "DragViewController")
        options = instantiateVC(withID: "OptionsViewController")
        window?.contentViewController = drag
    }

    func presentDrag() {
        window?.contentViewController = drag
        allowOptionsMenu(false)
    }

    func presentOptions(for image: NSImage) {
        options?.origImage = image
        allowOptionsMenu(true)
        window?.contentViewController = options
    }

    // MARK: - In Front

    var main = false

    func windowDidBecomeMain(_: Notification) {
        if !main {
            addMainItems()
            main = true
        }

        if window?.contentViewController == options {
            allowOptionsMenu(true)
        }
    }

    func windowDidResignMain(_: Notification) {
        if main {
            removeMainItems()
            main = false
        }
    }

    // MARK: - Menu

    var generateAction: Selector { #selector(options?.generate) }
    var newImageAction: Selector { #selector(options?.newImage) }
    var undoAction: Selector { #selector(options?.undo) }
    var redoAction: Selector { #selector(options?.redo) }

    let fileText = "File"
    let editText = "Edit"
    let undoText = "Undo"
    let redoText = "Redo"
    let closeText = "Close"
    let newImageText = "New Image"
    let generateIconsText = "Generate Icons"

    func addMainItems() {
        let new = NSMenuItem(title: newImageText, action: nil, keyEquivalent: "n")
        let export = NSMenuItem(title: generateIconsText, action: nil, keyEquivalent: "e")
        fileMenu.insertItem(export, at: 0)
        fileMenu.insertItem(new, at: 0)
        fileMenu.item(withTitle: closeText)?.action = nil
    }

    func removeMainItems() {
        fileMenu.removeItem(at: 0)
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

    func allowOptionsMenu(_ allowed: Bool) {
        fileMenu.item(withTitle: newImageText)?.action = allowed ? newImageAction : nil
        fileMenu.item(withTitle: generateIconsText)?.action = allowed ? generateAction : nil

        if !allowed {
            allowUndo(false)
            allowRedo(false)
        }
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
