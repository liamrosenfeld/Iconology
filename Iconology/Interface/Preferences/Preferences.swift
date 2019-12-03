//
//  Preferences.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

class Preferences {
    var useXcode: Bool {
        didSet {
            UserDefaults.standard.set(useXcode, forKey: Keys.useXcode.rawValue)
        }
    }
    var useFiles: Bool {
        didSet {
            UserDefaults.standard.set(useFiles, forKey: Keys.useFiles.rawValue)
        }
    }
    var useSets: Bool {
        didSet {
            UserDefaults.standard.set(useSets, forKey: Keys.useSets.rawValue)
        }
    }
    var openFolder: Bool {
        didSet {
            UserDefaults.standard.set(openFolder, forKey: Keys.openFolder.rawValue)
        }
    }
    var continuousPreview: Bool {
        didSet {
            UserDefaults.standard.set(continuousPreview, forKey: Keys.continuousPreview.rawValue)
        }
    }
    
    init() {
        self.useXcode   = UserDefaults.standard.bool(forKey: Keys.useXcode.rawValue)
        self.useFiles   = UserDefaults.standard.bool(forKey: Keys.useFiles.rawValue)
        self.useSets    = UserDefaults.standard.bool(forKey: Keys.useSets.rawValue)
        self.openFolder = UserDefaults.standard.bool(forKey: Keys.openFolder.rawValue)
        self.continuousPreview = UserDefaults.standard.bool(forKey: Keys.continuousPreview.rawValue)
    }
    
    enum Keys: String {
        case useXcode
        case useFiles
        case useSets
        case openFolder
        case continuousPreview
    }
}


