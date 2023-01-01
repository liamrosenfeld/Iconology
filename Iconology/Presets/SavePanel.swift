//
//  SavePanel.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/4/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

enum SavePanel {
    static func folderAndPrefix() -> (dir: URL, prefix: String)? {
        let openPanel = NSOpenPanel()
        
        // create panel
        openPanel.title = "Select a folder to save your icons"
        openPanel.prompt = "Save"
        openPanel.showsResizeIndicator = true
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.canCreateDirectories = true
        
        // add prefix accessory view
        let observablePrefix = ObservableWrapper("")
        let accessoryView = NSHostingView(rootView: PrefixSelector(prefix: observablePrefix))
        openPanel.accessoryView = accessoryView
        openPanel.isAccessoryViewDisclosed = true
        
        // get url to save to
        let response = openPanel.runModal()
        guard response == .OK else { return nil }
        guard let url = openPanel.url else { return nil }
        
        return (url, observablePrefix.content)
    }
    
    static func file(type: UTType) -> URL? {
        let savePanel = NSSavePanel()
        
        // create panel
        savePanel.title = "Save Your Icon"
        savePanel.allowedContentTypes = [type]
        savePanel.isExtensionHidden = false
        
        // get url to save to
        let response = savePanel.runModal()
        guard response == .OK else { return nil }
        return savePanel.url
    }
    
    private struct PrefixSelector: View {
        @ObservedObject var prefix: ObservableWrapper<String>
        
        var body: some View {
            HStack {
                Text("Individual File Prefix:")
                TextField("Prefix", text: $prefix.content)
                    .frame(maxWidth: 150)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

class ObservableWrapper<T>: ObservableObject {
    @Published var content: T
    
    init(_ item: T) {
        content = item
    }
}
