//
//  PresetsViewController.swift
//  Iconology
//
//  Created by Liam on 1/25/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

protocol PresetDelegate {
    func presetsSelected(_ preset: Preset)
}

class PresetsViewController: NSViewController {
    
    // MARK: - Setup
    var delegate: PresetDelegate?
    
    @IBOutlet weak var presetSelector: NSPopUpButton!
    @IBOutlet weak var presetGroupSelector: NSPopUpButton!
    
    var presets = [PresetGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPresets()
        setNotifications()
        selectedPreset(self)
    }
    
    enum PresetErrors: Error {
        case invalidSelection
    }
    
    // MARK: - Preset Cycle
    func setNotifications() {
        NotificationCenter.default.addObserver(forName: Notifications.preferencesApply, object: nil, queue: nil, using: reloadPresets)
        NotificationCenter.default.addObserver(forName: Notifications.presetApply, object: nil, queue: nil, using: presetApply)
    }
    
    func loadPresets() {
        // UI Preperation
        presetGroupSelector.removeAllItems()
        presetSelector.removeAllItems()
        
        // Load Presets
        if Storage.userPresets.presets.isEmpty {
            print("adding example custom presets...")
            ExamplePresets.addExamplePresets()
        }
        let customPresets = PresetGroup(title: "Custom", presets: Storage.userPresets.presets)
        
        // Combine Presets
        presets.append(contentsOf: Storage.defaultPresets.presets)
        presets.append(customPresets)
        
        // Display Presets
        for presetGroup in presets {
            presetGroupSelector.addItem(withTitle: presetGroup.title)
        }
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        for preset in presets[selectedGroup].presets {
            presetSelector.addItem(withTitle: preset.name)
        }
    }
    
    func reloadPresets(_ notification: Notification) {
        presets.removeAll()
        loadPresets()
        presetApply(notification)
    }
    
    func presetApply(_ notification: Notification) {
        // Reload Custom Presets
        let customGroupIndex = self.presetGroupSelector.indexOfItem(withTitle: "Custom")
        self.presets[customGroupIndex].presets = Storage.userPresets.presets
        
        // Update UI
        let currentGroupIndex = self.presetGroupSelector.indexOfSelectedItem
        if currentGroupIndex == customGroupIndex {
            self.presetSelector.removeAllItems()
            let group = self.presets[customGroupIndex]
            for preset in group.presets {
                self.presetSelector.addItem(withTitle: preset.name)
            }
            self.selectedPreset(self)
        }
    }
    
    // MARK: - Interactions
    func getSelectedPreset() throws -> Preset {
        // Check User Options
        let selectedPreset = presetSelector.indexOfSelectedItem
        guard selectedPreset != -1 else {
            throw PresetErrors.invalidSelection
        }
        
        // Convert and Save
        let group = presets[presetGroupSelector.indexOfSelectedItem]
        let preset = group.presets[presetSelector.indexOfSelectedItem]
        return preset
    }
    
    // MARK: - Actions
    @IBAction func selectedPresetGroup(_ sender: Any) {
        presetSelector.removeAllItems()
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        for preset in presets[selectedGroup].presets {
            presetSelector.addItem(withTitle: preset.name)
        }
        selectedPreset(self)
    }
    
    @IBAction func selectedPreset(_ sender: Any) {
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        let selectedPreset = presetSelector.indexOfSelectedItem
        
        guard selectedPreset != -1 else {
            Alerts.warningPopup(title: "Invalid Preset", text: "Please Select a Preset")
            return
        }
        
        let preset = presets[selectedGroup].presets[selectedPreset]
        delegate?.presetsSelected(preset)
    }
    
    @IBAction func editCustomPresets(_ sender: Any) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.editCustomPresets(self)
    }
    
}
