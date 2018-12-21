//
//  Dictionary+Presets.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}
