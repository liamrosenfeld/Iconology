//
//  URL+NSImage.swift
//  Iconology
//
//  Created by Liam on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

extension URL {
    func toImage() throws -> NSImage {
        var imageData: Data!
        
        do {
            imageData = try NSData(contentsOf: self, options: NSData.ReadingOptions()) as Data
        } catch {
            print("URL to Image Error: \(error)")
            throw error
        }
        
        enum AdditonalErrors: Error {
            case dataToImage
        }
        
        guard let image = NSImage(data: imageData) else {
            print("ERR: Data to Image")
            throw AdditonalErrors.dataToImage
        }
        
        return image
    }
}
