//
//  FileHandler.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

extension NSImage {
    static var extendedImageTypes: [String] {
        var allowed = NSImage.imageTypes
        allowed.append(contentsOf: ["com.adobe.illustrator.ai-image"])
        return allowed
    }
}

extension NSOpenPanel {
    func selectImage() -> URL? {
        self.title = "Select an Image to Convert"
        self.showsResizeIndicator = true
        self.canChooseDirectories = false
        self.canChooseFiles = true
        self.allowsMultipleSelection = false
        self.canCreateDirectories = true
        self.allowedFileTypes = NSImage.extendedImageTypes

        self.runModal()

        return self.url
    }

    func selectSaveFolder() -> URL? {
        self.title = "Select a folder to save your icons"
        self.prompt = "Save"
        self.showsResizeIndicator = true
        self.canChooseDirectories = true
        self.canChooseFiles = false
        self.allowsMultipleSelection = false
        self.canCreateDirectories = true

        self.runModal()

        return self.url
    }
}
