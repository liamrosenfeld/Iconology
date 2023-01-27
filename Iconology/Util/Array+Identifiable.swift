//
//  Array+Identifiable.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/5/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func withId(_ id: Element.ID) -> Element? {
        self.first(where: { $0.id == id })
    }
    
    func indexWithId(_ id: Element.ID) -> Int? {
        self.firstIndex(where: { $0.id == id })
    }
}
