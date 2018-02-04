//
//  OptionsViewController.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    // MARK: - Setup
    @IBOutlet weak var xcodeVersionSelector: NSPopUpButton!
    @IBOutlet weak var iPhoneToggle: NSButton!
    @IBOutlet weak var iPadToggle: NSButton!
    @IBOutlet weak var macToggle: NSButton!
    
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageURL!)
    }
    
    // MARK: - Actions
    @IBAction func convert(_ sender: Any) {
        // Check User Options
        let xcodeVersion = xcodeVersionSelector.titleOfSelectedItem!
        let iPhoneEnabled = iPhoneToggle.state.rawValue
        let iPadEnabled = iPadToggle.state.rawValue
        let macEnabled = macToggle.state.rawValue
        
        // Get Imnage from URL
        let imageToConvert = urlToImage(url: imageURL!)
        
        // Where to save
        let chosenFolder = selectFolder()
        if chosenFolder == "canceled" { return }
        let saveDirectory = URL(string: "\(chosenFolder)Icons/")
        print(saveDirectory!)
        createFolder(directory: saveDirectory!)
        
        // Convert and Save
        if xcodeVersion == "9" {
            if iPhoneEnabled == 1 {
                xcode9_iPhone(image: imageToConvert, url: saveDirectory!)
            }
            if iPadEnabled == 1 {
                xcode9_iPad(image: imageToConvert, url: saveDirectory!)
            }
            if macEnabled == 1 {
                xcode9_mac(image: imageToConvert, url: saveDirectory!)
            }
        } else if xcodeVersion == "8" {
            if iPhoneEnabled == 1 {
                xcode8_iPhone(image: imageToConvert, url: saveDirectory!)
            }
            if iPadEnabled == 1 {
                xcode8_iPad(image: imageToConvert, url: saveDirectory!)
            }
            if macEnabled == 1 {
                xcode8_mac(image: imageToConvert, url: saveDirectory!)
            }
        }
        
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
