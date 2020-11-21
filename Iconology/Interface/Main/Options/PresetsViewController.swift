//
//  PresetsViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/25/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

protocol PresetDelegate {
    func presetSelected(_ preset: Preset)
}

class PresetsViewController: NSViewController {
    // MARK: - Setup

    var delegate: PresetDelegate?

    @IBOutlet var presetSelector: NSPopUpButton!
    @IBOutlet var presetGroupSelector: NSPopUpButton!

    var presets = [PresetGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = view // Load View Hierarchy
        loadPresets()
        setNotifications()
        selectedPreset(self)
    }

    enum PresetErrors: Error {
        case invalidSelection
    }

    // MARK: - Preset Cycle

    func setNotifications() {
        NotificationCenter.default.addObserver(forName: .newDefaultPresets,
                                               object: nil,
                                               queue: nil,
                                               using: reloadDefault)
        NotificationCenter.default.addObserver(forName: .customPresetsEdited,
                                               object: nil,
                                               queue: nil,
                                               using: reloadCustom)
        NotificationCenter.default.addObserver(forName: .customPresetsReset,
                                               object: nil,
                                               queue: nil,
                                               using: reloadCustom)
    }

    let customText = "Custom"

    func loadPresets() {
        // UI Preparation
        presetGroupSelector.removeAllItems()
        presetSelector.removeAllItems()

        // Load Presets
        let customPresets = PresetGroup(title: customText, presets: Storage.userPresets.presets)

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

    func reloadDefault(_ : Notification) {
        presets.removeAll()
        loadPresets()
        selectedPreset(self)
    }

    func reloadCustom(_ : Notification) {
        // Reload Custom Presets
        let customGroupIndex = presetGroupSelector.indexOfItem(withTitle: customText)
        presets[customGroupIndex].presets = Storage.userPresets.presets

        // Update UI
        let currentGroupIndex = presetGroupSelector.indexOfSelectedItem
        if currentGroupIndex == customGroupIndex {
            presetSelector.removeAllItems()
            let group = presets[customGroupIndex]
            for preset in group.presets {
                presetSelector.addItem(withTitle: preset.name)
            }
            selectedPreset(self)
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

    @IBAction func selectedPresetGroup(_: Any) {
        presetSelector.removeAllItems()
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        for preset in presets[selectedGroup].presets {
            presetSelector.addItem(withTitle: preset.name)
        }
        selectedPreset(self)
    }

    @IBAction func selectedPreset(_: Any) {
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        let selectedPreset = presetSelector.indexOfSelectedItem

        guard selectedPreset != -1 else {
            Alerts.warningPopup(title: "Invalid Preset", text: "Please Select a Preset")
            return
        }

        let preset = presets[selectedGroup].presets[selectedPreset]
        delegate?.presetSelected(preset)
    }

    @IBAction func editCustomPresets(_: Any) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.editCustomPresets(self)
    }
}
