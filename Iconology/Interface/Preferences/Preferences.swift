//
//  Preferences.swift
//  Iconology
//
//  Created by Liam on 1/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Foundation

class Preferences {
    var useXcode: Bool
    var useFiles: Bool
    var useSets: Bool
    var openFolder: Bool
    
    init() {
        self.useXcode   = UserDefaults.standard.bool(forKey: Keys.useXcode.rawValue)
        self.useFiles   = UserDefaults.standard.bool(forKey: Keys.useFiles.rawValue)
        self.useSets    = UserDefaults.standard.bool(forKey: Keys.useSets.rawValue)
        self.openFolder = UserDefaults.standard.bool(forKey: Keys.openFolder.rawValue)
    }
    
    func update(useXcode: Bool, useFiles: Bool, useSets: Bool, openFolder: Bool) {
        self.useXcode   = useXcode
        self.useFiles   = useFiles
        self.useSets    = useSets
        self.openFolder = openFolder
        save()
    }
    
    func save() {
        UserDefaults.standard.set(useXcode, forKey: Keys.useXcode.rawValue)
        UserDefaults.standard.set(useFiles, forKey: Keys.useFiles.rawValue)
        UserDefaults.standard.set(useSets, forKey: Keys.useSets.rawValue)
        UserDefaults.standard.set(openFolder, forKey: Keys.openFolder.rawValue)
    }
    
    enum Keys: String {
        case useXcode = "useXcode"
        case useFiles = "useFiles"
        case useSets = "useSets"
        case openFolder = "openFolder"
    }
}


