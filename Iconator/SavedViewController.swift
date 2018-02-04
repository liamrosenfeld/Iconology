//
//  SavedViewController.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/4/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class SavedViewController: NSViewController {
    
    var savedDirectory: URL?
    
    @IBOutlet weak var savedText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directoryString = directory!.path
        self.savedText.stringValue = "Saved to \(directoryString)"
    }
    
}
