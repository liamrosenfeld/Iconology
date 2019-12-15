//
//  AllowedFileTypes.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/29/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

var allowedFileTypes: [String] {
    var allowed = NSImage.imageTypes
    allowed.append(contentsOf: ["com.adobe.illustrator.ai-image"])
    return allowed
}
