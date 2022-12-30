//
//  SwiftUI+Introspect.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/29/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import Introspect

extension View {
    public func dialSliderStyle() -> some View {
        introspectSlider { slider in
            slider.sliderType = .circular
        }
    }
    
    public func preventSidebarCollapse() -> some View {
        introspectSplitView { splitView in
            (splitView.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
        }
    }

    func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
        return inject(AppKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.findAncestorOrAncestorChild(ofType: NSSplitView.self, from: viewHost)
            },
            customize: customize
        ))
    }
}
