//
//  MainWindowController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/20/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
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
    }
    
    func presentOptions(for image: NSImage) {
        options?.origImage = image
        window?.contentViewController = options
    }
}
