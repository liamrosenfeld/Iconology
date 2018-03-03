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
    @IBOutlet weak var xcodeVersionSelector: NSPopUpButton!
    @IBOutlet weak var iOSToggle: NSButton!
    @IBOutlet weak var macToggle: NSButton!
    @IBOutlet weak var iMessageToggle: NSButton!
    @IBOutlet weak var watchToggle: NSButton!
    
    var imageURL: NSURL?
    var saveDirectory: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageURL!)
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
    @IBAction func convert(_ sender: Any) {
        // Check User Options
        let xcodeVersion = xcodeVersionSelector.titleOfSelectedItem!
        let iOSEnabled = iOSToggle.state.rawValue
        let macEnabled = macToggle.state.rawValue
        let iMessageEnabled = iMessageToggle.state.rawValue
        let watchEnabled = watchToggle.state.rawValue
        
        // Get Image from URL
        let imageToConvert = urlToImage(url: imageURL!)
        
        // Where to save
        let chosenFolder = selectFolder()
        if chosenFolder == "canceled" { return }
        saveDirectory = URL(string: "\(chosenFolder)Icons/")
        print(saveDirectory!)
        createFolder(directory: saveDirectory!)
        
        // Convert and Save
        if xcodeVersion == "9" {
            if iOSEnabled == 1 {
                xcode9_iOS(image: imageToConvert, url: saveDirectory!)
            }
            if macEnabled == 1 {
                xcode9_mac(image: imageToConvert, url: saveDirectory!)
            }
            if iMessageEnabled == 1 {
                xcode9_iMessage(image: imageToConvert, url: saveDirectory!)
            }
            if watchEnabled == 1 {
                xcode9_watch(image: imageToConvert, url: saveDirectory!)
            }
        } else if xcodeVersion == "8" {
            if iOSEnabled == 1 {
                xcode8_iOS(image: imageToConvert, url: saveDirectory!)
            }
            if macEnabled == 1 {
                xcode8_mac(image: imageToConvert, url: saveDirectory!)
            }
            if iMessageEnabled == 1 {
                xcode8_iMessage(image: imageToConvert, url: saveDirectory!)
            }
            if watchEnabled == 1 {
                xcode8_watch(image: imageToConvert, url: saveDirectory!)
            }
        }
        
        segue(to: "SavedVC")
        
    }
   
    @IBAction func back(_ sender: Any) {
        segue(to: "DragVC")
    }
    
    
    // MARK: - Convert Between URL, Data, and Image
    func urlToImage(url: NSURL) -> NSImage {
        do {
            let imageData = try NSData(contentsOf: url as URL, options: NSData.ReadingOptions())
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
