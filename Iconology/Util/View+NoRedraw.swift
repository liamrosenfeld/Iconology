//
//  View+NoRedraw.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/25/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI

fileprivate struct NoRedrawView<T: View>: View, Equatable {
    let content: T
    
    var body: some View {
        content
    }
    
    static func == (lhs: NoRedrawView, rhs: NoRedrawView) -> Bool { true }
}

extension View {
    /// Prevents the SwiftUI Renderer from ever thinking the view needs to be redrawn
    func dontRedraw() -> some View {
        EquatableView(content: NoRedrawView(content: self))
    }
}
