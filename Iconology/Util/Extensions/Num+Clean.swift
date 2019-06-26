//
//  Double+Util.swift
//  Iconology
//
//  Created by Liam on 12/22/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : self.description
    }
}

extension CGFloat {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : self.description
    }
}
