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
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var aspectRatioLabel: NSTextField!
    
    @IBOutlet weak var imageVCContainer: NSView!
    @IBOutlet weak var presetVCContainer: NSView!
    
    
    var imageOptionsVC: ImageOptionsViewController!
    var presetsVC: PresetsViewController!
    
    var imageURL: URL?
    var origImage: NSImage!
    var imageToConvert: NSImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageFrom(imageURL)
        addChildren()
    }
    
    func addChildren() {
        imageOptionsVC = self.storyboard?.instantiateController(withIdentifier: "ImageOptionsVC") as? ImageOptionsViewController
        imageOptionsVC.delegate = self
        addChildVC(imageOptionsVC, to: imageVCContainer)
        
        presetsVC = self.storyboard?.instantiateController(withIdentifier: "PresetsVC") as? PresetsViewController
        presetsVC.delegate = self
        addChildVC(presetsVC, to: presetVCContainer)
    }
    
    func segue(to: String) {
        if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("HomeViewController")) as? HomeViewController
            view.window?.contentViewController = dragViewController
        }
    }
    
    
    // MARK: - Actions
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
        preset.save(imageToConvert, at: saveDirectory, with: imageOptionsVC.prefix)
        
        Alerts.success(title: "Saved!", text: "Image Was Saved With The Preset \(preset.name)")
        
        if Storage.preferences.openFolder {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: saveDirectory.path)
        }
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
    }
    
    // MARK: - Image Stuff
    func addImageFrom( _ url: URL?) {
        // Retrieve From URL
        guard let url = imageURL else {
            Alerts.warningPopup(title: "Image Not Selected", text: "No Image Was Selected")
            print("ERR: URL is Nil")
            return
        }
        guard let image = NSImage(contentsOf: url) else {
            Alerts.warningPopup(title: "Image Not Found", text: "'\(url.path)' No Longer Exists'")
            print("ERR: File Could No Longer Be Found")
            return
        }
        
        // Add Image
        imageToConvert = image
        origImage = image
        addImage(image)
    }
    
    func addImage(_ image: NSImage) {
        imageView.resize(to: imageToConvert)
        imageView.addImage(imageToConvert)
        alignAspectLabel()
    }
    
    func setAspect(_ aspect: NSSize) {
        imageOptionsVC.mods.aspect = aspect
        aspectRatioLabel.stringValue = "Aspect: \(aspect.width.clean):\(aspect.height.clean)"
        imageToConvert = imageOptionsVC.mods.apply(on: origImage)
        addImage(imageToConvert)
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
        guard let imageOptionsVC = imageOptionsVC else {
            print("ERR: ImageOptionsVC Not Loaded")
            return
        }
        imageOptionsVC.setMods(from: preset)
        setAspect(preset.aspect)
    }
}
