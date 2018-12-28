//
//  PreferencesViewController.swift
//  Iconology
//
//  Created by Liam on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func resetCustomPresets(_ sender: Any) {
        let comfirm = Alerts.comfirmPopup(title: "Warning", text: "This will delete all your presets")
        if comfirm {
            UserPresets.deleteAllPreset()
        }
    }
}
