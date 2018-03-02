//
//  SavedViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 2/4/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class SavedViewController: NSViewController {
    
    // Setup
    var savedDirectory: URL?
    
    @IBOutlet weak var savedText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directoryString = directory!.path
        self.savedText.stringValue = "Saved to \(directoryString)"
    }
    
    // Actions
    @IBAction func another(_ sender: Any) {
        let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DragViewController")) as? DragViewController
        view.window?.contentViewController = dragViewController
    }
    
}
