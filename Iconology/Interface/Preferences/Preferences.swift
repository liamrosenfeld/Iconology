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
        didSet { Preferences.setValue(for: .useXcode, to: useXcode) }
    }

    var useFiles: Bool {
        didSet { Preferences.setValue(for: .useFiles, to: useFiles) }
    }

    var useSets: Bool {
        didSet { Preferences.setValue(for: .useSets, to: useSets) }
    }

    // general
    var openFolder: Bool {
        didSet { Preferences.setValue(for: .openFolder, to: openFolder) }
    }

    var continuousPreview: Bool {
        didSet { Preferences.setValue(for: .continuousPreview, to: continuousPreview) }
    }

    // util
    static func setValue(for key: Key, to value: Bool) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func getValue(for key: Key) -> Bool {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Bool ?? false
    }

    init() {
        if !UserDefaults.standard.bool(forKey: Key.notFirstLaunch.rawValue) {
            Preferences.setValue(for: .notFirstLaunch, to: true)
            useXcode = true
            useFiles = true
            useSets = true
            openFolder = true
            continuousPreview = true
        }

        useXcode = Preferences.getValue(for: .useXcode)
        useFiles = Preferences.getValue(for: .useFiles)
        useSets = Preferences.getValue(for: .useSets)
        openFolder = Preferences.getValue(for: .openFolder)
        continuousPreview = Preferences.getValue(for: .continuousPreview)
    }

    enum Key: String {
        case notFirstLaunch
        case useXcode
        case useFiles
        case useSets
        case openFolder
        case continuousPreview
    }
}
