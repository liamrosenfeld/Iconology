//
//  Formatter+Static.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/25/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension Formatter {
    static func boundDecimal(min: Double, max: Double) -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.hasThousandSeparators = false
        formatter.maximumFractionDigits = 2
        formatter.minimum = min as NSNumber
        formatter.maximum = max as NSNumber
        return formatter
    }
    
    static let posInt: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.hasThousandSeparators = false
        formatter.minimum = 1
        return formatter
    }()
}
