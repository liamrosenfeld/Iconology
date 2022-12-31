//
//  ImageSelection.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa
import UniformTypeIdentifiers

extension NSImage {
    static var extendedContentTypes: [UTType] = {
        var allowed = NSImage.imageTypes.compactMap { UTType($0) }
        allowed.append(UTType("com.adobe.illustrator.ai-image")!)
        return allowed
    }()
}

extension NSOpenPanel {
    func selectImage() -> URL? {
        self.title = "Select an Image to Convert"
        self.showsResizeIndicator = true
        self.canChooseDirectories = false
        self.canChooseFiles = true
        self.allowsMultipleSelection = false
        self.canCreateDirectories = true
        self.allowedContentTypes = NSImage.extendedContentTypes

        self.runModal()

        return self.url
    }
}
