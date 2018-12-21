//
//  OptionsViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    // MARK: - Setup
    @IBOutlet weak var presetSelector: NSPopUpButton!
    @IBOutlet weak var presetGroupSelector: NSPopUpButton!
    @IBOutlet weak var prefixView: NSView!
    @IBOutlet weak var prefixTextBox: NSTextField!
    @IBOutlet weak var prefixPreview: NSTextField!
    
    var imageURL: URL?
    var saveDirectory: URL?
    var presets = [PresetGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Preperation
        prefixView.isHidden = true
        presetGroupSelector.removeAllItems()
        presetSelector.removeAllItems()
        
        // Load Presets
        if UserPresets.presets.isEmpty {
            print("adding example custom presets...")
            ExamplePresets.addExamplePresets()
        }
        let customPresets = PresetGroup(title: "Custom", presets: UserPresets.presets)
        
        // Combine Presets
        presets.append(contentsOf: DefaultPresets.presets)
        presets.append(customPresets)
        
        // Display Presets
        for presetGroup in presets {
            presetGroupSelector.addItem(withTitle: presetGroup.title)
        }
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        for preset in presets[selectedGroup].presets {
            presetSelector.addItem(withTitle: preset.name)
        }
        selectedPreset(self)
        
        // Set Reload Notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DismissSheet"), object: nil, queue: nil) { notification in
            self.presetSelector.removeAllItems()
            let group = self.presets[self.presetGroupSelector.indexOfSelectedItem]
            for preset in group.presets {
                self.presetSelector.addItem(withTitle: preset.name)
            }
            self.selectedPreset(self)
        }
    }
    
    func segue(to: String) {
        if (to == "SavedVC"){
            let savedViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SavedViewController")) as? SavedViewController
            savedViewController?.savedDirectory = saveDirectory!
            view.window?.contentViewController = savedViewController
        } else if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DragViewController")) as? DragViewController
            view.window?.contentViewController = dragViewController
        }
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
        
        if selectedPreset != -1 {
            if presets[selectedGroup].presets[selectedPreset].usePrefix {
                prefixView.isHidden = false
            } else {
                prefixView.isHidden = true
            }
        } else {
            prefixView.isHidden = true
        }
    }
    
    @IBAction func prefixTextEdited(_ sender: Any) {
        let group = presets[presetGroupSelector.indexOfSelectedItem]
        // TODO: Update On Type
        if presetSelector.indexOfSelectedItem < group.presets.count && presetSelector.indexOfSelectedItem != -1 {
            // TODO: Get Example Of Root File Name
            let root = "root"
            let prefix = prefixTextBox.stringValue
            prefixPreview.stringValue = "Ex: \(prefix)\(root).type"
        } else {
            let prefix = prefixTextBox.stringValue
            prefixPreview.stringValue = "Ex: \(prefix)root.type"
        }
    }
    
    @IBAction func convert(_ sender: Any) {
        // Check User Options
        let selectedPreset = presetSelector.indexOfSelectedItem
        if selectedPreset == -1 {
            // TODO: Warning Popup
            print("ERR: Invalid Preset")
            return
        }
        
        // Get Image from URL
        var imageToConvert: NSImage!
        do {
            imageToConvert = try imageURL?.toImage()
        } catch {
            // TODO: Warning Popup
            print("ERR: File Could No Longer Be Found")
            return
        }
        
        // Convert and Save
        let group = presets[presetGroupSelector.indexOfSelectedItem]
        let preset = group.presets[presetSelector.indexOfSelectedItem]
        
        // Where to Save
        let folder = selectFolder()
        guard let chosenFolder = folder else { return }
        saveDirectory = chosenFolder.appendingPathComponent(preset.folderName)
        print(saveDirectory!)
        createFolder(directory: saveDirectory!)
        
        // Save
        preset.save(imageToConvert, at: saveDirectory!, with: prefixTextBox.stringValue)
        
        segue(to: "SavedVC")
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
    }
    
    
}
