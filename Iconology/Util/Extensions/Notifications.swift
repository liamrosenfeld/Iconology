//
//  Notifications.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/24/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension Notification.Name {
    static let customPresetsEdited = Notification.Name(rawValue: "CustomPresetsEdited")
    static let newDefaultPresets = Notification.Name(rawValue: "NewDefaultPresets")
    static let generalPrefApply = Notification.Name(rawValue: "GeneralPrefApply")
    static let customPresetsReset = Notification.Name(rawValue: "CustomPresetsReset")
}
