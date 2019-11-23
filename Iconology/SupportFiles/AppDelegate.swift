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
        openNoRepeat(sender: sender, existing: &preferencesWindowController, name: "Preferences")
    }
    
    @IBAction func editCustomPresets(_ sender: Any) {
        openNoRepeat(sender: sender, existing: &presetsWindowController, name: "Presets")
    }
    
    func openNoRepeat(sender: Any, existing: inout NSWindowController?, name: String) {
        if let windowController = existing {
            windowController.showWindow(sender)
        } else {
            let storyboard = NSStoryboard(name: name, bundle: Bundle.main)
            existing = storyboard.instantiateInitialController() as? NSWindowController
            existing!.window?.makeKeyAndOrderFront(nil)
        }
    }
    
}

