//
//  Formatter+Static.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/25/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension Formatter {
    static let floatFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.hasThousandSeparators = false
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    static let intFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.hasThousandSeparators = false
        return formatter
    }()
}
