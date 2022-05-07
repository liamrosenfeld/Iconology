//
//  CustomPresetsView.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/4/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import Introspect

struct CustomPresetsView: View {
    @EnvironmentObject var store: CustomPresetsStore
    @State private var selection: Preset.ID?
    
    var body: some View {
        NavigationView {
            CustomPresetSelector(selection: $selection)
                .introspectSplitView { controller in
                    // prevent the sidebar from being hidden
                    (controller.delegate as? NSSplitViewController)?.splitViewItems.first?.canCollapse = false
                }
                .frame(minWidth: 200)
            Group {
                if store.presets.count == 0 {
                    Text("Create a Preset to Edit")
                        .navigationTitle("")
                } else if let selection = selection {
                    CustomPresetEditor(presetSelection: selection)
                } else {
                    Text("Select a Preset to Edit")
                        .navigationTitle("")
                }
            }.frame(minWidth: 300)
        }
        .frame(minWidth: 600, minHeight: 325)
    }
}

struct CustomPresetsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPresetsView()
    }
}

// MARK: - Preventing Sidebar From Being Hidden
extension View {
    public func introspectSplitView(customize: @escaping (NSSplitView) -> ()) -> some View {
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
