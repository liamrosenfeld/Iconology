//
//  Preferences.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

class Preferences {
    // default presets
    var useXcode: Bool {
        didSet { setValue(for: .useXcode, to: useXcode) }
    }

    var useFiles: Bool {
        didSet { setValue(for: .useFiles, to: useFiles) }
    }

    var useSets: Bool {
        didSet { setValue(for: .useSets, to: useSets) }
    }

    // general
    var openFolder: Bool {
        didSet { setValue(for: .openFolder, to: openFolder) }
    }

    var continuousPreview: Bool {
        didSet { setValue(for: .continuousPreview, to: continuousPreview) }
    }

    // util
    func setValue(for key: Key, to value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    init() {
        useXcode = UserDefaults.standard.bool(forKey: Key.useXcode.rawValue)
        useFiles = UserDefaults.standard.bool(forKey: Key.useFiles.rawValue)
        useSets = UserDefaults.standard.bool(forKey: Key.useSets.rawValue)
        openFolder = UserDefaults.standard.bool(forKey: Key.openFolder.rawValue)
        continuousPreview = UserDefaults.standard.bool(forKey: Key.continuousPreview.rawValue)
    }

    enum Key: String {
        case useXcode
        case useFiles
        case useSets
        case openFolder
        case continuousPreview
    }
}
