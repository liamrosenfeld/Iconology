//
//  PresetViewController.swift
//  Iconology
//
//  Created by Liam on 5/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PresetViewController: NSViewController {
    
    // MARK: - Properties
    @IBOutlet weak var selectContainer: NSView!
    @IBOutlet weak var editContainer: NSView!
    
    var selectVC: SelectPresetViewController!
    var editVC: EditPresetViewController!
    var winController: PresetsWindowController!
    
    var tempPresets = Storage.userPresets.presets
    var selectedPreset = 0 {
        didSet {
            editVC.reloadUI()
        }
    }
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildren()
        
        NotificationCenter.default.addObserver(forName: Notifications.customPresetsReset, object: nil, queue: nil) { _ in
            self.discardEditing()
        }
    }
    
    override func viewDidAppear() {
        winController = self.view.window?.windowController as? PresetsWindowController
    }
    
    func addChildren() {
        selectVC = self.storyboard?.instantiateController(withIdentifier: "SelectPresetVC") as? SelectPresetViewController
        selectVC.delegate = self
        addChildVC(selectVC, to: selectContainer)
        
        editVC = self.storyboard?.instantiateController(withIdentifier: "EditPresetVC") as? EditPresetViewController
        editVC.delegate = self
        editVC.reloadUI()
        addChildVC(editVC, to: editContainer)
    }
    
    // MARK: - Saving
    @IBAction func apply(_ sender: Any) {
        let _ = commitEditing()
    }
    
    override func commitEditing() -> Bool {
        Storage.userPresets.presets = tempPresets
        Storage.userPresets.savePresets()
        NotificationCenter.default.post(name: Notifications.presetApply, object: nil)
        winController.edited = false
        return true
    }
    
    override func discardEditing() {
        tempPresets = Storage.userPresets.presets
        self.editVC.reloadUI()
        self.selectVC.presetTable.reloadData()
        winController.edited = false
    }
}

// MARK: - Delegates
extension PresetViewController: SelectPresetDelegate {
    func presetSelected(withIndex index: Int) {
        selectedPreset = index
    }
    
    func addPreset(named name: String) {
        tempPresets.append(CustomPreset(name: name, sizes: [ImgSetPreset.ImgSetSize]()))
        winController.edited = true
    }
    
    func removePreset(at index: Int) {
        tempPresets.remove(at: index)
        winController.edited = true
    }
    
    func presetRenamed(to name: String, forIndex index: Int) {
        tempPresets[index].name = name
        winController.edited = true
    }
    
    var presets: [CustomPreset] { return tempPresets }
}

extension PresetViewController: EditPresetDelegate {
    func removeSize(at index: Int) {
        tempPresets[selectedPreset].sizes.remove(at: index)
        winController.edited = true
    }
    
    func appendSize(_ size: ImgSetPreset.ImgSetSize) {
        tempPresets[selectedPreset].sizes.append(size)
        winController.edited = true
    }
    
    func changeName(at index: Int, to name: String) {
        tempPresets[selectedPreset].sizes[index].name = name
        winController.edited = true
    }
    
    func changeWidth(at index: Int, to size: Int) {
        tempPresets[selectedPreset].sizes[index].size.width = CGFloat(size)
        winController.edited = true
    }
    
    func changeHeight(at index: Int, to size: Int) {
        tempPresets[selectedPreset].sizes[index].size.height = CGFloat(size)
        winController.edited = true
    }
    
    func changeAspect(to aspect: NSSize) {
        tempPresets[selectedPreset].aspect = aspect
        winController.edited = true
    }
    
    var preset: CustomPreset? {
        if selectedPreset >= 0 && selectedPreset < tempPresets.count {
            return tempPresets[selectedPreset]
        } else {
            return nil
        }
    }
}
