//
//  ImageRetriever.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/7/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

class ImageRetriever: DropDelegate, ObservableObject {
    @Published private(set) var image: CGImage?
    @Published private(set) var isDropping: Bool
    
    static let dragTypes: [UTType] = [.fileURL]
    
    init() {
        self.image = nil
        self.isDropping = false
    }
    
    init(image: CGImage) {
        self.image = image
        self.isDropping = false
    }
    
    // MARK: - From URL
    func selectImage() {
        imageFromUrl(NSOpenPanel().selectImage())
    }

    private func imageFromUrl(_ url: URL?) {
        guard let url = url else { return }
        guard let image = NSImage(contentsOf: url) else {
            // TODO: throw so error can be shown
            return
        }
        DispatchQueue.main.async {
            self.image = image.cgImage
        }
    }
    
    // MARK: - Drop Delegate
    func validateDrop(info: DropInfo) -> Bool {
        // get provider
        let providers = info.itemProviders(for: [.fileURL])
        guard providers.count == 1 else { return false }
        guard let provider = providers.first else { return false }

        // create dispatch group
        var allowed = false
        let group = DispatchGroup()
        group.enter()

        // wait on provider to load and then get UTI
        provider.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { (urlData, _) in
            if let urlData = urlData {
                let url = URL(dataRepresentation: urlData, relativeTo: nil, isAbsolute: true)
                if let uti = (try? url?.resourceValues(forKeys: [.contentTypeKey]))?.contentType {
                    allowed = NSImage.extendedContentTypes.contains(uti)
                }
            }
            group.leave()
        }

        // return if is allowed
        group.wait()
        return allowed
    }

    func performDrop(info: DropInfo) -> Bool {
        // get provider
        let providers = info.itemProviders(for: [.fileURL])
        guard let provider = providers.first else { return false }

        // wait on provider to load and then get UTI
        provider.loadDataRepresentation(forTypeIdentifier: UTType.fileURL.identifier) { (urlData, _) in
            if let urlData = urlData {
                self.imageFromUrl(URL(dataRepresentation: urlData, relativeTo: nil, isAbsolute: true))
            }
        }

        return true
    }

    func dropEntered(info: DropInfo) {
        withAnimation(.easeIn(duration: 0.15)) {
            self.isDropping = true
        }
    }

    func dropExited(info: DropInfo) {
        withAnimation(.easeOut(duration: 0.50)) {
            self.isDropping = false
        }
    }
}
