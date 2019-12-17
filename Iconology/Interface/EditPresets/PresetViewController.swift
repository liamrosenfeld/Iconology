//
//  PresetViewController.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/10/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class PresetViewController: NSViewController {
    // MARK: - Properties

    @IBOutlet var selectContainer: NSView!
    @IBOutlet var editContainer: NSView!

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

        NotificationCenter.default.addObserver(forName: .customPresetsReset,
                                               object: nil,
                                               queue: nil,
                                               using: { [weak self] (_: Notification) in self?.discardEditing() })
    }

    override func viewDidAppear() {
        winController = view.window?.windowController as? PresetsWindowController
        allowUndoRedo()
    }

    func addChildren() {
        selectVC = storyboard?.instantiateController(withIdentifier: "SelectPresetVC") as? SelectPresetViewController
        selectVC.delegate = self
        addChildVC(selectVC, to: selectContainer)

        editVC = storyboard?.instantiateController(withIdentifier: "EditPresetVC") as? EditPresetViewController
        editVC.delegate = self
        editVC.reloadUI()
        addChildVC(editVC, to: editContainer)
    }

    // MARK: - Saving

    @IBAction func save(_: Any) {
        _ = commitEditing()
    }

    override func commitEditing() -> Bool {
        Storage.userPresets.presets = tempPresets
        Storage.userPresets.savePresets()
        NotificationCenter.default.post(name: .customPresetsEdited, object: nil)
        winController.edited = false
        return true
    }

    override func discardEditing() {
        tempPresets = Storage.userPresets.presets
        editVC.reloadUI()
        selectVC.presetTable.reloadData()
        winController.edited = false
    }

    // MARK: - Import and Export

    @IBAction func export(_: Any) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tempPresets[selectedPreset])
            FileHandler.saveJson(from: data)
        } catch {
            print("ERR: Json Encoding Error - \(error)")
        }
    }

    @IBAction func importPressed(_: Any) {
        let decoder = JSONDecoder()
        guard let data = FileHandler.selectJson() else { return }

        do {
            let preset = try decoder.decode(CustomPreset.self, from: data)
            tempPresets.append(preset)
            selectVC.presetTable.reloadData()
            winController.edited = true
        } catch {
            Alerts.warningPopup(title: "JSON File Not Compatable",
                                text: "Please make sure the imported file is created with Iconology")
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

    func registerUndo(_ action: @escaping (PresetViewController) -> Void) {
        undoManager?.registerUndo(withTarget: self) { this in
            action(this)
        }

        allowUndoRedo()
    }

    func allowUndoRedo() {
        winController.allowUndo(undoManager?.canUndo ?? false)
        winController.allowRedo(undoManager?.canRedo ?? false)
    }
}
