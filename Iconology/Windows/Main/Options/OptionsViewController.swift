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
    @IBOutlet weak var prefixView: NSView!
    @IBOutlet weak var prefixTextBox: NSTextField!
    @IBOutlet weak var prefixPreview: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var aspectRatioLabel: NSTextField!
    
    var imageOptionsVC: ImageOptionsViewController!
    var presetsVC: PresetsViewController!
    
    var imageURL: URL?
    
    var origImage: NSImage!
    var imageToConvert: NSImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        prefixPreview.stringValue = ""
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageOptionsChildSegue" {
            imageOptionsVC = segue.destinationController as? ImageOptionsViewController
            imageOptionsVC.delegate = self
        } else if segue.identifier == "presetsChildSegue" {
            presetsVC = segue.destinationController as? PresetsViewController
            presetsVC.delegate = self
        }
    }
    
    func segue(to: String) {
        if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
            view.window?.contentViewController = dragViewController
        }
    }
    
    
    // MARK: - Actions
    @IBAction func prefixTextEdited(_ sender: Any) {
        let prefix = prefixTextBox.stringValue
        prefixPreview.stringValue = "Ex: \(prefix)root.type"
    }
    
    @IBAction func convert(_ sender: Any) {
        var preset: Preset!
        do {
            try preset = presetsVC.getSelectedPreset()
        } catch let error {
            print("ERR: \(error)")
            Alerts.warningPopup(title: "Invalid Preset", text: "Please Select a Preset")
            return
        }
        
        // Where to Save
        let folder = FileHandler.selectFolder()
        guard let chosenFolder = folder else { return }
        let saveDirectory = chosenFolder.appendingPathComponent(preset.folderName)
        print(saveDirectory)
        FileHandler.createFolder(directory: saveDirectory)
        
        // Save
        preset.save(imageToConvert, at: saveDirectory, with: prefixTextBox.stringValue)
        
        Alerts.success(title: "Saved!", text: "Image Was Saved With The Preset \(preset.name)")
        
        if Storage.preferences.openFolder {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: saveDirectory.path)
        }
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
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

extension OptionsViewController: ImageOptionsDelegate, PresetDelegate {
    func modsChanged(_ mods: ImageModifications) {
        imageToConvert = mods.apply(on: origImage)
        imageView.addImage(imageToConvert)
    }
    
    func presetsSelected(_ preset: Preset) {
        imageOptionsVC.setMods(from: preset)
        prefixView.isHidden = !preset.useModifications.prefix
        setAspect(preset.aspect)
    }
}
