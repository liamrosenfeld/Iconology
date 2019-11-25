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
        drag = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DragViewController")) as? DragViewController
        options = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("OptionsViewController")) as? OptionsViewController
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
    
    func windowDidBecomeMain(_ notification: Notification) {
        if !main {
            addMainItems()
            main = true
        }
        
        if window?.contentViewController == options {
            allowOptionsMenu(true)
        }
    }
    
    func windowDidResignMain(_ notification: Notification) {
        if main {
            removeMainItems()
            main = false
        }
    }
    
    // MARK: - Menu
    var generateAction: Selector { #selector(options?.generate) }
    var newImageAction: Selector? = nil // TODO
    var undoAction: Selector { #selector(options?.undo) }
    var redoAction: Selector { #selector(options?.redo) }
    
    let fileText = "File"
    let editText = "Edit"
    let undoText = "Undo"
    let redoText = "Redo"
    let newImageText = "New Image"
    let generateIconsText = "Generate Icons"
    
    func addMainItems() {
        let new = NSMenuItem(title: newImageText, action: nil, keyEquivalent: "n")
        let export = NSMenuItem(title: generateIconsText, action: nil, keyEquivalent: "e")
        fileMenu.insertItem(export, at: 0)
        fileMenu.insertItem(new, at: 0)
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
    
    func allowOptionsMenu(_ on: Bool) {
        fileMenu.item(withTitle: newImageText)?.action = on ? newImageAction : nil
        fileMenu.item(withTitle: generateIconsText)?.action = on ? generateAction : nil
        
        if !on {
            allowUndo(false)
            allowRedo(false)
        }
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
