//
//  PngGenerator.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/4/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation
import CoreGraphics

enum ImgSetGenerator {
    static func savePngs(_ image: CGImage, at url: URL, with prefix: String, in sizes: [ImgSetSize]) {
        for size in sizes {
            let resizedImage = image.resized(to: size.size, quality: .high)
            let name = "\(prefix)\(size.name)"
            let url = url.appendingPathComponent("\(name).png")
            do {
                try resizedImage.savePng(to: url)
            } catch {
                print("ERR: \(error)")
            }
        }
    }
}
