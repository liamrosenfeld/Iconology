//
//  PreferencesViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/28/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet var xcodeToggle: NSButton!
    @IBOutlet var fileToggle: NSButton!
    @IBOutlet var setToggle: NSButton!
    @IBOutlet var openFolderToggle: NSButton!
    @IBOutlet var continuousPreviewToggle: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        xcodeToggle.state = Storage.preferences.useXcode ? .on : .off
        fileToggle.state = Storage.preferences.useFiles ? .on : .off
        setToggle.state = Storage.preferences.useSets ? .on : .off
        openFolderToggle.state = Storage.preferences.openFolder ? .on : .off
        continuousPreviewToggle.state = Storage.preferences.continuousPreview ? .on : .off
    }

    @IBAction func resetCustomPresets(_: Any) {
        let confirm = Alerts.confirmPopup(title: "Warning", text: "This will delete all your presets")
        if confirm {
            Storage.userPresets.deleteAllPreset()
            ExamplePresets.addExamplePresets()
            NotificationCenter.default.post(name: .customPresetsReset, object: nil)
        }
    }

    @IBAction func applyDefaultPresets(_: Any) {
        Storage.preferences.useXcode = xcodeToggle.state == .on
        Storage.preferences.useFiles = fileToggle.state == .on
        Storage.preferences.useSets = setToggle.state == .on
        Storage.defaultPresets.fill() // triggers newDefaultPresets notif
    }

    @IBAction func applyGeneral(_: Any) {
        Storage.preferences.openFolder = openFolderToggle.state == .on
        Storage.preferences.continuousPreview = continuousPreviewToggle.state == .on
        NotificationCenter.default.post(name: .generalPrefApply, object: nil)
    }
}
