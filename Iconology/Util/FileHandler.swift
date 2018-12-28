//
//  FileHandler.swift
//  Iconology
//
//  Created by Liam on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

struct FileHandler {
    static func chooseFile(_ callingClass: String = #function) -> URL? {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select an Image to Convert "
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = true
        selectPanel.canChooseFiles = true
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true
        selectPanel.allowedFileTypes = allowedFileTypes
        selectPanel.delegate = callingClass as? NSOpenSavePanelDelegate
        
        selectPanel.runModal()
        
        guard let url = selectPanel.url else {
            return nil
        }
        
        return url
    }
    
    static func selectFolder(_ callingClass: String = #function) -> URL? {
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
    
    
    static func createFolder(directory: URL) {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Folder Creation Error: \(error.localizedDescription)")
        }
        
    }
}

