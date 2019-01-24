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
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var aspectRatioLabel: NSTextField!
    
    var imageOptionsVC: ImageOptionsViewController!
    
    var imageURL: URL?
    var presets = [PresetGroup]()
    var origImage: NSImage!
    var imageToConvert: NSImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Preperation
        presetGroupSelector.removeAllItems()
        presetSelector.removeAllItems()
        
        // Load Presets
        if Presets.userPresets.presets.isEmpty {
            print("adding example custom presets...")
            ExamplePresets.addExamplePresets()
        }
        let customPresets = PresetGroup(title: "Custom", presets: Presets.userPresets.presets)
        
        // Combine Presets
        presets.append(contentsOf: Presets.defaultPresets.presets)
        presets.append(customPresets)
        
        // Display Presets
        for presetGroup in presets {
            presetGroupSelector.addItem(withTitle: presetGroup.title)
        }
        let selectedGroup = presetGroupSelector.indexOfSelectedItem
        for preset in presets[selectedGroup].presets {
            presetSelector.addItem(withTitle: preset.name)
        }
        prefixPreview.stringValue = ""
        
        // Set Reload Notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name("PresetApply"), object: nil, queue: nil, using: presetApply)
        
        // Get Image
        let image = NSImage(contentsOf: imageURL!)
        if image != nil {
            imageToConvert = image!
            origImage = image!
        } else {
            Alerts.warningPopup(title: "Image Not Found", text: "'\(imageURL?.path ?? "File")' No Longer Exists'")
            print("ERR: File Could No Longer Be Found")
            return
        }
        
        // Display Image
        imageView.resize(to: imageToConvert)
        imageView.addImage(imageToConvert)
        alignAspectLabel()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageOptionsChildSegue" {
            imageOptionsVC = segue.destinationController as? ImageOptionsViewController
            imageOptionsVC.delegate = self
            selectedPreset(self)
        }
    }
    
    func segue(to: String) {
        if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
            view.window?.contentViewController = dragViewController
        }
    }
    
    func presetApply(_ notification: Notification) {
        // Reload Custom Presets
        let customGroupIndex = self.presetGroupSelector.indexOfItem(withTitle: "Custom")
        self.presets[customGroupIndex].presets = Presets.userPresets.presets
        
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
            let preset = presets[selectedGroup].presets[selectedPreset]
            imageOptionsVC.setMods(from: preset)
            prefixView.isHidden = !preset.useModifications.prefix
            setAspect(preset.aspect)
        } else {
            // TODO: Handle Error
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
            Alerts.warningPopup(title: "Invalid Preset", text: "Please Select a Preset")
            print("ERR: Invalid Preset")
            return
        }
        
        // Convert and Save
        let group = presets[presetGroupSelector.indexOfSelectedItem]
        let preset = group.presets[presetSelector.indexOfSelectedItem]
        
        // Where to Save
        let folder = FileHandler.selectFolder()
        guard let chosenFolder = folder else { return }
        let saveDirectory = chosenFolder.appendingPathComponent(preset.folderName)
        print(saveDirectory)
        FileHandler.createFolder(directory: saveDirectory)
        
        // Save
        preset.save(imageToConvert, at: saveDirectory, with: prefixTextBox.stringValue)
        
        Alerts.success(title: "Saved!", text: "Image Was Saved With The Preset \(preset.name)")
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
    }
    
    @IBAction func editCustomPresets(_ sender: Any) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.editCustomPresets(self)
    }
    
    func setAspect(_ aspect: NSSize) {
        imageOptionsVC.mods.aspect = aspect
        aspectRatioLabel.stringValue = "Aspect: \(aspect.width.clean):\(aspect.height.clean)"
        imageToConvert = imageOptionsVC.mods.apply(on: origImage)
        imageView.resize(to: imageToConvert)
        imageView.addImage(imageToConvert)
        alignAspectLabel()
    }
    
    func alignAspectLabel() {
        let x = imageView.frame.origin.x
        let y = imageView.frame.size.height + imageView.frame.origin.y
        let origin = NSPoint(x: x, y: y)
        let rect = NSRect(origin: origin, size: aspectRatioLabel.frame.size)
        aspectRatioLabel.frame = rect
    }
    
}

extension OptionsViewController: ImageOptionsDelegate {
    func modsChanged(_ mods: ImageModifications) {
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
}
