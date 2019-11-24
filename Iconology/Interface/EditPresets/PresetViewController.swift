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
        allowUndoRedo()
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
    @objc @IBAction func save(_ sender: Any) {
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
    
    // MARK: - Import and Export
    @IBAction func export(_ sender: Any) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tempPresets[selectedPreset])
            FileHandler.saveJson(from: data)
        } catch {
            print("ERR: Json Encoding Error - \(error)")
        }
        
    }
    
    @IBAction func importPressed(_ sender: Any) {
        let decoder = JSONDecoder()
        guard let data = FileHandler.selectJson() else { return }
        
        do {
            let preset = try decoder.decode(CustomPreset.self, from: data)
            tempPresets.append(preset)
            selectVC.presetTable.reloadData()
            winController.edited = true
        } catch {
            Alerts.warningPopup(title: "JSON File Not Compatable", text: "Please make sure the imported file is created with Iconology")
            print("WARN: Json Decoding Error - \(error)")
        }
    }
    
    // MARK: - Undo/Redo
    @objc func undo() {
        undoManager?.undo()
    }
    
    @objc func redo() {
        undoManager?.redo()
    }
    
    func registerUndo(_ action: @escaping (PresetViewController) -> ()) {
        undoManager?.registerUndo(withTarget: self) { this in
            action(this)
            
            this.selectVC.presetTable.reloadData()
            this.editVC.presetTable.reloadData()
        }
        
        allowUndoRedo()
    }
    
    func allowUndoRedo() {
        winController.allowUndo(undoManager?.canUndo ?? false)
        winController.allowRedo(undoManager?.canRedo ?? false)
    }
    
}

// MARK: - Delegates
extension PresetViewController: SelectPresetDelegate {
    func presetSelected(at index: Int) {
        selectedPreset = index
    }
    
    func addPreset(_ preset: CustomPreset, at index: Int?) {
        let index = index ?? tempPresets.endIndex
        tempPresets.insert(preset, at: index)
        registerUndo { $0.removePreset(at: index) }
        winController.edited = true
    }
    
    func removePreset(at index: Int) {
        let removed = tempPresets.remove(at: index)
        registerUndo { $0.addPreset(removed, at: index) }
        winController.edited = true
    }
    
    func presetRenamed(to name: String, forIndex index: Int) {
        let oldName = tempPresets[index].name
        tempPresets[index].name = name
        registerUndo { $0.presetRenamed(to: oldName, forIndex: index) }
        winController.edited = true
    }
    
    var presets: [CustomPreset] { return tempPresets }
}

extension PresetViewController: EditPresetDelegate {
    func removeSize(at index: Int) {
        let removed = tempPresets[selectedPreset].sizes.remove(at: index)
        registerUndo { $0.addSize(removed, at: index) }
        winController.edited = true
    }
    
    func addSize(_ size: ImgSetPreset.ImgSetSize, at index: Int?) {
        let index = index ?? tempPresets[selectedPreset].sizes.endIndex
        tempPresets[selectedPreset].sizes.insert(size, at: index)
        registerUndo { $0.removeSize(at: index) }
        winController.edited = true
    }
    
    func changeName(at index: Int, to name: String) {
        let oldName = tempPresets[selectedPreset].sizes[index].name
        tempPresets[selectedPreset].sizes[index].name = name
        registerUndo { $0.changeName(at: index, to: oldName) }
        winController.edited = true
    }
    
    func changeWidth(at index: Int, to size: Int) {
        let oldSize = Int(tempPresets[selectedPreset].sizes[index].size.width)
        tempPresets[selectedPreset].sizes[index].size.width = CGFloat(size)
        registerUndo { $0.changeWidth(at: index, to: oldSize) }
        winController.edited = true
    }
    
    func changeHeight(at index: Int, to size: Int) {
        let oldSize = Int(tempPresets[selectedPreset].sizes[index].size.height)
        tempPresets[selectedPreset].sizes[index].size.height = CGFloat(size)
        registerUndo { $0.changeHeight(at: index, to: oldSize) }
        winController.edited = true
    }
    
    func changeAspect(to aspect: NSSize) {
        let oldAspect = tempPresets[selectedPreset].aspect
        tempPresets[selectedPreset].aspect = aspect
        registerUndo { $0.changeAspect(to: oldAspect) }
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
