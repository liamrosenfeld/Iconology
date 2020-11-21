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

    @IBOutlet var imageView: NSImageView!
    @IBOutlet var aspectRatioLabel: NSTextField!

    @IBOutlet var imageVCContainer: NSView!
    @IBOutlet var presetVCContainer: NSView!

    var imageOptionsVC: ImageOptionsViewController!
    var presetsVC: PresetsViewController!

    var winController: MainWindowController!

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

    override func viewDidAppear() {
        winController = view.window?.windowController as? MainWindowController
        allowUndoRedo()
        imageOptionsVC.resetAll() // resets image modifications
    }

    func addChildren() {
        imageOptionsVC = instantiateVC(withID: "ImageOptionsVC")
        imageOptionsVC.mods = ImageModifier(image: origImage!) { modImage in
            self.imageView.addImage(modImage)
        }
        addChildVC(imageOptionsVC, to: imageVCContainer)

        presetsVC = instantiateVC(withID: "PresetsVC")
        presetsVC.delegate = self
        addChildVC(presetsVC, to: presetVCContainer)
    }

    // MARK: - Interface Management

    func reloadUI() {
        guard let image = origImage else { return }
        imageOptionsVC.mods.origImage = image
        displayImage()
    }

    func displayImage() {
        imageView.resize(to: imageOptionsVC.mods.image)
        imageView.addImage(imageOptionsVC.mods.image)
        alignAspectLabel()
    }

    func alignAspectLabel() {
        let x = imageView.frame.origin.x
        let y = imageView.frame.size.height + imageView.frame.origin.y
        let origin = NSPoint(x: x, y: y)
        let rect = NSRect(origin: origin, size: aspectRatioLabel.frame.size)
        aspectRatioLabel.frame = rect
    }

    // MARK: - Actions

    @IBAction func generate(_: Any) {
        var preset: Preset!
        do {
            try preset = presetsVC.getSelectedPreset()
        } catch {
            print("ERR: \(error)")
            Alerts.warningPopup(title: "Invalid Preset", text: "Please Select a Preset")
            return
        }

        // Where to Save
        let folder = FileHandler.selectSaveFolder()
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

    @objc func newImage() {
        guard let url = FileHandler.selectImage() else {
            return
        }

        do {
            origImage = try url.toImage()
        } catch URL.ImageError.imageNotFound {
            Alerts.warningPopup(title: "Image Not Found", text: "'\(url.path)' No Longer Exists'")
            print("ERR: File Could No Longer Be Found")
        } catch {
            print("Unexpected error: \(error).")
        }
    }

    @IBAction func back(_: Any) {
        //swiftlint:disable force_cast
        let windowController = view.window?.windowController as! MainWindowController
        windowController.presentDrag()
    }

    // MARK: - Undo/Redo
    // TODO: Undo and Redo for Adjustments
    @objc func undo() {
        print("TODO: Undo")
        undoManager?.undo()
    }

    @objc func redo() {
        print("TODO: Redo")
        undoManager?.redo()
    }

    func allowUndoRedo() {
        winController.allowUndo(undoManager?.canUndo ?? false)
        winController.allowRedo(undoManager?.canRedo ?? false)
    }
}

extension OptionsViewController: PresetDelegate {
    func presetSelected(_ preset: Preset) {
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
