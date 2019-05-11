//
//  PresetViewController.swift
//  Iconology
//
//  Created by Liam on 5/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PresetViewController: NSViewController {

    @IBOutlet weak var selectContainer: NSView!
    @IBOutlet weak var editContainer: NSView!
    
    var selectVC: SelectPresetViewController!
    var editVC: EditPresetViewController!
    
    var tempPresets = Storage.userPresets.presets
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildren()
        
        NotificationCenter.default.addObserver(forName: Notifications.preferencesApply, object: nil, queue: nil) { _ in
            self.tempPresets = Storage.userPresets.presets
            self.selectVC.presetTable.reloadData()
        }
    }
    
    func addChildren() {
        selectVC = self.storyboard?.instantiateController(withIdentifier: "SelectPresetVC") as? SelectPresetViewController
        selectVC.delegate = self
        addChildVC(selectVC, to: selectContainer)
        
        editVC = self.storyboard?.instantiateController(withIdentifier: "EditPresetVC") as? EditPresetViewController
        if (selectVC.presetSelected < tempPresets.count) && (selectVC.presetSelected != -1) {
            editVC.tempSave = tempPresets[selectVC.presetSelected]
        } else {
            editVC.tempSave = nil
        }
        addChildVC(editVC, to: editContainer)
    }
    
    @IBAction func apply(_ sender: Any) {
        if let edited = editVC.tempSave {
            tempPresets[currentIndex] = edited
        }
        Storage.userPresets.presets = tempPresets
        Storage.userPresets.savePresets()
        NotificationCenter.default.post(name: Notifications.presetApply, object: nil)
    }
}

extension PresetViewController: SelectPresetDelegate {
    func presetSelected(withIndex index: Int) {
        if index != -1 {
            if let edited = editVC.tempSave {
                if currentIndex < tempPresets.count {
                    tempPresets[currentIndex] = edited
                }
            }
            editVC.tempSave = tempPresets[index]
            currentIndex = index
        } else {
            editVC.tempSave = nil
        }
    }
    
    func addPreset(named name: String) {
        tempPresets.append(CustomPreset(name: name, sizes: [ImgSetPreset.ImgSetSize]()))
    }
    
    func removePreset(at index: Int) {
        tempPresets.remove(at: index)
    }
    
    func presetRenamed(to name: String, forIndex index: Int) {
        tempPresets[index].name = name
    }
    
    var presets: [CustomPreset] { return tempPresets }
}
