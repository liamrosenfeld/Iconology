//
//  MainWindowController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/20/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    var home: HomeViewController?
    var options: OptionsViewController?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        home = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
        options = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("OptionsViewController")) as? OptionsViewController
        window?.contentViewController = home
    }
    
    func presentHome() {
        window?.contentViewController = home
    }
    
    func presentOptions(for image: NSImage) {
        options?.origImage = image
        window?.contentViewController = options
    }
}
