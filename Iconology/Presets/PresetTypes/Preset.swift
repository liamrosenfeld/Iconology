//
//  Preset.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

protocol Preset {
    var name: String { get }
    var folderName: String { get }
    var usePrefix: Bool { get }
    var aspect: NSSize { get }
    
    func save(_ image: NSImage, at url: URL, with prefix: String)
}

protocol Size {
    var name: String { get }
}
