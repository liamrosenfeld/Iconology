//
//  Folders.swift
//  Iconology
//
//  Created by Liam on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

func selectFolder(_ callingClass: String = #function) -> URL? {
    let selectPanel = NSOpenPanel()
    selectPanel.title = "Select a folder to save your icons"
    selectPanel.showsResizeIndicator = true
    selectPanel.canChooseDirectories = true
    selectPanel.canChooseFiles = false
    selectPanel.allowsMultipleSelection = false
    selectPanel.canCreateDirectories = true
    selectPanel.delegate = callingClass as? NSOpenSavePanelDelegate
    
    selectPanel.runModal()
    
    guard let url = selectPanel.url else {
        return nil
    }
    
    return url
}

func createFolder(directory: URL) {
    do {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
    } catch let error as NSError {
        print("Folder Creation Error: \(error.localizedDescription)")
    }
    
}
