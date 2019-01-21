//
//  AppDelegate.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window: AnyObject in sender.windows {
                window.makeKeyAndOrderFront(self)
            }
        }
        return true
    }
    
    // MARK: - Extra Windows
    var preferencesWindowController: NSWindowController?
    var presetsWindowController: NSWindowController?
    
    @IBAction func preferences(_ sender: Any) {
        if let windowController = preferencesWindowController {
            windowController.showWindow(sender)
        } else {
            let storyboard = NSStoryboard(name: "Preferences", bundle: Bundle.main)
            preferencesWindowController = storyboard.instantiateInitialController() as? NSWindowController
            preferencesWindowController!.window?.makeKeyAndOrderFront(nil)
            preferencesWindowController!.window?.level = .floating
        }
        
    }
    
    @IBAction func editCustomPresets(_ sender: Any) {
        if let windowController = presetsWindowController {
            windowController.showWindow(sender)
        } else {
            let storyboard = NSStoryboard(name: "Presets", bundle: Bundle.main)
            presetsWindowController = storyboard.instantiateInitialController() as? NSWindowController
            presetsWindowController!.window?.makeKeyAndOrderFront(nil)
            presetsWindowController!.window?.level = .floating
        }
    }
    
}

