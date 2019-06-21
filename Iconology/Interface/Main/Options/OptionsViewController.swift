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
    
    var origImage: NSImage? {
        didSet {
            if imageOptionsVC != nil {
                reloadUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildren()
        reloadUI()
    }
    
    func addChildren() {
        imageOptionsVC = self.storyboard?.instantiateController(withIdentifier: "ImageOptionsVC") as? ImageOptionsViewController
        imageOptionsVC.mods = ImageModifier(image: origImage!) { modImage in
            self.imageView.addImage(modImage)
        }
        addChildVC(imageOptionsVC, to: imageVCContainer)
        
        presetsVC = self.storyboard?.instantiateController(withIdentifier: "PresetsVC") as? PresetsViewController
        presetsVC.delegate = self
        addChildVC(presetsVC, to: presetVCContainer)
    }
    
    // MARK: - Interface Management
    func reloadUI() {
        resetMods()
        displayImage()
        alignAspectLabel()
    }
    
    func resetMods() {
        guard let image = origImage else { return }
        imageOptionsVC.mods.origImage = image
        imageOptionsVC.resetAll()
    }
    
    func displayImage() {
        imageView.resize(to: imageOptionsVC.mods.image)
        imageView.addImage(imageOptionsVC.mods.image)
    }
    
    func alignAspectLabel() {
        let x = imageView.frame.origin.x
        let y = imageView.frame.size.height + imageView.frame.origin.y
        let origin = NSPoint(x: x, y: y)
        let rect = NSRect(origin: origin, size: aspectRatioLabel.frame.size)
        aspectRatioLabel.frame = rect
    }
    
    
    // MARK: - Actions
    @IBAction func convert(_ sender: Any) {
        var preset: Preset!
        do {
            try preset = presetsVC.getSelectedPreset()
        } catch {
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
        preset.save(imageOptionsVC.mods.image, at: saveDirectory, with: imageOptionsVC.prefix)
        
        Alerts.success(title: "Saved!", text: "Image Was Saved With The Preset \(preset.name)")
        
        if Storage.preferences.openFolder {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: saveDirectory.path)
        }
    }
   
    @IBAction func back(_ sender: Any) {
        toHomeVC()
    }
    
    func toHomeVC() {
        let windowController = view.window?.windowController as! MainWindowController
        windowController.presentHome()
    }
    
}

extension OptionsViewController: PresetDelegate {
    func presetsSelected(_ preset: Preset) {
        guard let imageOptionsVC = imageOptionsVC else {
            print("ERR: ImageOptionsVC Not Loaded")
            return
        }
        imageOptionsVC.setMods(from: preset)
        setAspect(preset.aspect)
        displayImage()
    }
    
    func setAspect(_ aspect: NSSize) {
        imageOptionsVC.mods.aspect = aspect
        aspectRatioLabel.stringValue = "Aspect: \(aspect.width.clean):\(aspect.height.clean)"
    }
}
