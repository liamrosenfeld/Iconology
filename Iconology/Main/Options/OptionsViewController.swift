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
    
    var imageURL: URL?
    var saveDirectory: URL?
    var presets = [PresetGroup]()
    var origImage: NSImage!
    var imageToConvert: NSImage!
    
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
        
        // Set Reload Notification
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DismissSheet"), object: nil, queue: nil) { notification in
            self.presetSelector.removeAllItems()
            let group = self.presets[self.presetGroupSelector.indexOfSelectedItem]
            for preset in group.presets {
                self.presetSelector.addItem(withTitle: preset.name)
            }
            self.selectedPreset(self)
        }
        
        // Get Image
        let image = NSImage(contentsOf: imageURL!)
        if image != nil {
            imageToConvert = image!
            origImage = image!
        } else {
            // TODO: Warning Popup
            print("ERR: File Could No Longer Be Found")
            return
        }
        
        // Display Image
        imageView.resize(to: imageToConvert)
        imageView.addImage(imageToConvert)
        
        // Apply Selected Preset
        selectedPreset(self)
    }
    
    func segue(to: String) {
        if (to == "SavedVC"){
            let savedViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SavedViewController")) as? SavedViewController
            savedViewController?.savedDirectory = saveDirectory!
            view.window?.contentViewController = savedViewController
        } else if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
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
            let preset = presets[selectedGroup].presets[selectedPreset]
            if preset.usePrefix {
                prefixView.isHidden = false
            } else {
                prefixView.isHidden = true
            }
            
            setAspect(preset.aspect)
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
    
    
    // MARK: - Options
    @IBOutlet weak var backgroundToggle: NSButton!
    @IBOutlet weak var backgroundColor: NSColorWell!
    
    @IBOutlet weak var horizontalToggle: NSButton!
    @IBOutlet weak var horizontalShift: NSSlider!
    
    @IBOutlet weak var verticalToggle: NSButton!
    @IBOutlet weak var verticalShift: NSSlider!
    
    @IBOutlet weak var scaleToggle: NSButton!
    @IBOutlet weak var scaleSlider: NSSlider!
    
    var mods = ImageModifications()
    
    @IBAction func backgroundToggled(_ sender: Any) {
        switch backgroundToggle.state {
        case .on:
            mods.background = backgroundColor.color
        case .off:
            mods.background = nil
        default:
            print("ERR: Wrong Button State")
        }
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
    
    @IBAction func backgroundColorSelected(_ sender: Any) {
        backgroundToggled(self)
    }
    
    @IBAction func horizontalToggled(_ sender: Any) {
        switch horizontalToggle.state {
        case .on:
            let raw = horizontalShift.doubleValue
            let adjusted = (raw - 50) * 2
            mods.horizontalShift = CGFloat(adjusted)
        case .off:
            mods.horizontalShift = 0
        default:
            print("ERR: Wrong Button State")
        }
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
    
    @IBAction func horizontalShiftSelected(_ sender: Any) {
        horizontalToggled(self)
    }
    
    @IBAction func verticalToggled(_ sender: Any) {
        switch verticalToggle.state {
        case .on:
            let raw = verticalShift.doubleValue
            let adjusted = (raw - 50) * 2
            mods.verticalShift = CGFloat(adjusted)
        case .off:
            mods.verticalShift = 0
        default:
            print("ERR: Wrong Button State")
        }
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
    
    @IBAction func verticalShiftSelected(_ sender: Any) {
        verticalToggled(self)
    }
    
    @IBAction func scaleToggled(_ sender: Any) {
        switch scaleToggle.state {
        case .on:
            mods.scale = CGFloat(scaleSlider.doubleValue)
        case .off:
            mods.scale = 1
        default:
            print("ERR: Wrong Button State")
        }
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
    
    @IBAction func scaleSelected(_ sender: Any) {
        scaleToggled(self)
    }
    
    func setAspect(_ aspect: Aspect) {
        mods.aspect = aspect
        aspectRatioLabel.stringValue = "Aspect: \(aspect.w.clean):\(aspect.h.clean)"
        imageToConvert = mods.apply(on: origImage)
        imageView.resize(to: imageToConvert)
        imageView.addImage(imageToConvert)
    }
    
    struct ImageModifications {
        var background: NSColor?
        var verticalShift: CGFloat = 0
        var horizontalShift: CGFloat = 0
        var scale: CGFloat = 1
        var aspect: Aspect = Aspect(w: 1, h: 1)
        
        
        func apply(on image: NSImage) -> NSImage {
            var modImage = image
            
            if scale != 1 {
                modImage = modImage.scale(scale)
            }
            
            modImage = modImage.applyAspect(w: aspect.w, h: aspect.h)
            
            if verticalShift != 0 || horizontalShift != 0 {
                modImage = modImage.shift(x: horizontalShift, y: verticalShift)
            }
            
            if let backgroundColor = background {
                modImage = modImage.addBackground(backgroundColor)
            }
            
            return modImage
        }
    }
}
