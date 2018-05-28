//
//  OptionsViewController.swift
//  Iconizer
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    // MARK: - Setup
    @IBOutlet weak var presetSelector: NSPopUpButton!
    @IBOutlet weak var prefixView: NSView!
    @IBOutlet weak var prefixTextBox: NSTextField!
    
    var imageURL: URL?
    var saveDirectory: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI Preperation
        prefixView.isHidden = true
        presetSelector.removeAllItems()
        
        // Presets
        UserPresets.loadPresets()
        if UserPresets.presets.isEmpty {
            DefaultPresets().addDefaults()
        }
        for preset in UserPresets.presets {
            presetSelector.addItem(withTitle: preset.name)
        }
    }
    
    func segue(to: String) {
        if (to == "SavedVC"){
            let savedViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SavedViewController")) as? SavedViewController
            savedViewController?.savedDirectory = saveDirectory!
            view.window?.contentViewController = savedViewController
        }
        else if (to == "DragVC") {
            let dragViewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "DragViewController")) as? DragViewController
            view.window?.contentViewController = dragViewController
        }
    }
    
    // MARK: - Actions
    @IBAction func selectedPreset(_ sender: Any) {
        let selectedPreset = presetSelector.indexOfSelectedItem
        
        if UserPresets.presets[selectedPreset].usePrefix {
            prefixView.isHidden = false
        }
        else {
            prefixView.isHidden = true
        }
    }
    
    @IBAction func convert(_ sender: Any) {
        // Check User Options
        let selectedPreset = presetSelector.indexOfSelectedItem
        
        // Get Image from URL
        let imageToConvert = urlToImage(url: imageURL!)
        
        // Where to save
        let chosenFolder = selectFolder()
        if chosenFolder == "canceled" { return }
        saveDirectory = URL(string: "\(chosenFolder)Icons/")
        print(saveDirectory!)
        createFolder(directory: saveDirectory!)
        
        // Convert and Save
        if UserPresets.presets[selectedPreset].usePrefix {
            for (name, size) in UserPresets.presets[selectedPreset].sizes {
                resize(name: "\(prefixTextBox.stringValue)\(name)", image: imageToConvert, w: size.x, h: size.y, saveTo: saveDirectory!)
            }
        }
        else {
            for (name, size) in UserPresets.presets[selectedPreset].sizes {
                resize(name: name, image: imageToConvert, w: size.x, h: size.y, saveTo: saveDirectory!)
            }
        }
        
        segue(to: "SavedVC")
        
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
    }
    
    
    // MARK: - Convert Between URL, Data, and Image
    func urlToImage(url: URL) -> NSImage {
        do {
            let imageData = try NSData(contentsOf: url, options: NSData.ReadingOptions())
            return NSImage(data: imageData as Data)!
        } catch {
            print("URL to Image Error: \(error)")
        }
        // TODO: - Change the backup return (currently the upload icon)
        return #imageLiteral(resourceName: "uploadIcon")
    }
    
    // MARK: - Save
    func selectFolder() -> String {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select a folder to save your icons"
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = true
        selectPanel.canChooseFiles = false
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true
        selectPanel.delegate = self as? NSOpenSavePanelDelegate
        
        selectPanel.runModal()
        
        if selectPanel.url != nil {
            return String(describing: selectPanel.url!)
        } else {
            return "canceled"
        }
        
        
    }
    
    func createFolder(directory: URL) {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Folder Creation Error: \(error.localizedDescription)")
        }

    }
    
}
