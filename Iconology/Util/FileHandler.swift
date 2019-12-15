//
//  FileHandler.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

struct FileHandler {
    static func selectImage() -> URL? {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select an Image to Convert"
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = false
        selectPanel.canChooseFiles = true
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true
        selectPanel.allowedFileTypes = allowedFileTypes

        selectPanel.runModal()

        return selectPanel.url
    }

    static func selectSaveFolder() -> URL? {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select a folder to save your icons"
        selectPanel.prompt = "Save"
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = true
        selectPanel.canChooseFiles = false
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true

        selectPanel.runModal()

        return selectPanel.url
    }

    static func saveJson(from data: Data) {
        let savePanel = NSSavePanel()
        savePanel.title = "Save Your Preset File"
        savePanel.allowedFileTypes = ["public.json"]
        savePanel.isExtensionHidden = false

        savePanel.runModal()
        guard let url = savePanel.url else { return }

        FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }

    static func selectJson() -> Data? {
        let selectPanel = NSOpenPanel()
        selectPanel.title = "Select Your Preset File"
        selectPanel.showsResizeIndicator = true
        selectPanel.canChooseDirectories = false
        selectPanel.canChooseFiles = true
        selectPanel.allowsMultipleSelection = false
        selectPanel.canCreateDirectories = true
        selectPanel.allowedFileTypes = ["public.json"]

        selectPanel.runModal()
        guard let url = selectPanel.url else { return nil }

        return FileManager.default.contents(atPath: url.path)
    }

    static func createFolder(directory: URL) {
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Folder Creation Error: \(error.localizedDescription)")
        }
    }
}
