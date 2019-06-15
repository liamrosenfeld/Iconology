//
//  PreferencesViewController.swift
//  Iconology
//
//  Created by Liam on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    
    @IBOutlet weak var xcodeToggle: NSButton!
    @IBOutlet weak var fileToggle: NSButton!
    @IBOutlet weak var setToggle: NSButton!
    @IBOutlet weak var openFolderToggle: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton(xcodeToggle, to: Storage.preferences.useXcode)
        setButton(fileToggle,  to: Storage.preferences.useFiles)
        setButton(setToggle,   to: Storage.preferences.useSets)
        setButton(openFolderToggle, to: Storage.preferences.openFolder)
    }
    
    @IBAction func resetCustomPresets(_ sender: Any) {
        let comfirm = Alerts.comfirmPopup(title: "Warning", text: "This will delete all your presets")
        if comfirm {
            Storage.userPresets.deleteAllPreset()
            ExamplePresets.addExamplePresets()
            NotificationCenter.default.post(name: Notifications.customPresetsReset, object: nil)
        }
    }
    
    @IBAction func apply(_ sender: Any) {
        Storage.preferences.update(useXcode:   xcodeToggle.state == .on,
                                   useFiles:   fileToggle.state == .on,
                                   useSets:    setToggle.state == .on,
                                   openFolder: openFolderToggle.state == .on)
        Storage.defaultPresets.fill()
        NotificationCenter.default.post(name: Notifications.preferencesApply, object: nil)
    }
    
    func setButton(_ button: NSButton, to position: Bool) {
        if position {
            button.state = .on
        } else {
            button.state = .off
        }
    }
}
