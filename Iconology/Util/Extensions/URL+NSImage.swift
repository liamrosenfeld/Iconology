//
//  URL+NSImage.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 1/26/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension URL {
    func toImage() throws -> NSImage {
        guard let image = NSImage(contentsOf: self) else {
            throw ImageError.imageNotFound
        }

        return image
    }

    enum ImageError: Error {
        case imageNotFound
    }
}
