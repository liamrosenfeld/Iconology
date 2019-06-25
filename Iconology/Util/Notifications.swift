//
//  Notifications.swift
//  Iconology
//
//  Created by Liam on 1/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

enum Notifications {
    static let presetApply = Notification.Name(rawValue: "PresetApply")
    static let newDefaultPresets = Notification.Name(rawValue: "NewDefaultPresets")
    static let preferencesApply = Notification.Name(rawValue: "PreferencesApply")
    static let customPresetsReset = Notification.Name(rawValue: "CustomPresetsReset")
}
