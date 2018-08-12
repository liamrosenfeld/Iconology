//
//  Save.swift
//  Iconology
//
//  Created by Liam on 6/26/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func save(to: URL, name: String, image: NSImage) {
    let data: Data = image.tiffRepresentation!
    let filename = to.appendingPathComponent("\(name).png")
    try? data.write(to: filename)
}

func selectFolder(_ callingClass: String = #function) -> String {
    let selectPanel = NSOpenPanel()
    selectPanel.title = "Select a folder to save your icons"
    selectPanel.showsResizeIndicator = true
    selectPanel.canChooseDirectories = true
    selectPanel.canChooseFiles = false
    selectPanel.allowsMultipleSelection = false
    selectPanel.canCreateDirectories = true
    selectPanel.delegate = callingClass as? NSOpenSavePanelDelegate
    
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