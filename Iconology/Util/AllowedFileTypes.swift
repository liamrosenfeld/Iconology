//
//  AllowedFileTypes.swift
//  Iconology
//
//  Created by Liam on 12/29/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

var allowedFileTypes: [String] {
    get {
        var allowed = [String]()
        allowed.append(contentsOf: NSImage.imageTypes)
        let additional = ["com.adobe.illustrator.ai-image"]
        allowed.append(contentsOf: additional)
        return allowed
    }
}
