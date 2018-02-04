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
        let xcodeVersion = xcodeVersionSelector.titleOfSelectedItem!
        let iPhoneEnabled = iPhoneToggle.state.rawValue
        let iPadEnabled = iPadToggle.state.rawValue
        let macEnabled = macToggle.state.rawValue
        
        let imageToConvert = urlToImage(url: imageURL!)
        
        // Select where to save
        let chosenFolder = selectFolder()
        print(chosenFolder)
        createFolder(directory: chosenFolder)
        
        // Convert and Save
        if xcodeVersion == "9" {
            if iPhoneEnabled == 1 {
                xcode9_iPhone(image: imageToConvert)
            }
            if iPadEnabled == 1 {
                xcode9_iPad(image: imageToConvert)
            }
            if macEnabled == 1 {
                xcode9_mac(image: imageToConvert)
            }
        } else if xcodeVersion == "8" {
            if iPhoneEnabled == 1 {
                xcode8_iPhone(image: imageToConvert)
            }
            if iPadEnabled == 1 {
                xcode8_iPad(image: imageToConvert)
            }
            if macEnabled == 1 {
                xcode8_mac(image: imageToConvert)
            }
        }
        
    }
   
    
    // MARK: - Convert Between URL, Data, and Image
    func urlToImage(url: NSURL) -> NSImage {
        do {
            let imageData = try NSData(contentsOf: url as URL, options: NSData.ReadingOptions())
            return NSImage(data: imageData as Data)!
        } catch {
            print(error)
        }
        // Probally should change the backup return sometime
        return #imageLiteral(resourceName: "uploadIcon")
    }
    
    // MARK: - Save
    func selectFolder() -> URL {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select a folder to save your icons"
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = true
        selectPanel.canChooseFiles = false
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true
        selectPanel.delegate = self as? NSOpenSavePanelDelegate
        
        selectPanel.runModal()
        
        return selectPanel.url!
    }
    
    func createFolder(directory: URL) {
     

    }
    
}
