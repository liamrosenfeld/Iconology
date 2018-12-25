//
//  SavedViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/4/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class SavedViewController: NSViewController {
    
    // MARK: - Setup
    var savedDirectory: URL?
    
    @IBOutlet weak var savedText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directoryString = savedDirectory!.path
        self.savedText.stringValue = "Saved to \(directoryString)"
    }
    
    // MARK: - Actions
    @IBAction func another(_ sender: Any) {
        let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
        view.window?.contentViewController = dragViewController
    }
    
}
