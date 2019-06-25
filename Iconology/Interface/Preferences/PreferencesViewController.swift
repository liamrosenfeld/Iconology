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
    @IBOutlet weak var continuousPreviewToggle: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xcodeToggle.state = Storage.preferences.useXcode ? .on : .off
        fileToggle.state  = Storage.preferences.useFiles ? .on : .off
        setToggle.state   = Storage.preferences.useSets ? .on : .off
        openFolderToggle.state = Storage.preferences.openFolder ? .on : .off
        continuousPreviewToggle.state = Storage.preferences.continuousPreview ? .on : .off
    }
    
    @IBAction func resetCustomPresets(_ sender: Any) {
        let comfirm = Alerts.comfirmPopup(title: "Warning", text: "This will delete all your presets")
        if comfirm {
            Storage.userPresets.deleteAllPreset()
            ExamplePresets.addExamplePresets()
            NotificationCenter.default.post(name: Notifications.customPresetsReset, object: nil)
        }
    }
    
    @IBAction func applyDefaultPresets(_ sender: Any) {
        Storage.preferences.useXcode = xcodeToggle.state == .on
        Storage.preferences.useFiles = fileToggle.state  == .on
        Storage.preferences.useSets  = setToggle.state   == .on
        Storage.defaultPresets.fill()
        NotificationCenter.default.post(name: Notifications.newDefaultPresets, object: nil)
    }
    
    @IBAction func applyGeneral(_ sender: Any) {
        Storage.preferences.openFolder        = openFolderToggle.state        == .on
        Storage.preferences.continuousPreview = continuousPreviewToggle.state == .on
        NotificationCenter.default.post(name: Notifications.preferencesApply, object: nil)
    }
    
}
