//
//  SaveXcode.swift
//  Iconology
//
//  Created by Liam on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

func saveXcode(_ image: NSImage, at url: URL, in sizes: [XcodePreset.XcodeSizes]) {
    // Generate + Save Images
    for size in sizes {
        let x = Int(size.x * Double(exactly: size.scale)!)
        let y = Int(size.y * Double(exactly: size.scale)!)
        let resizedImage = image.resize(w: x, h: y)
        let url = url.appendingPathComponent("\(size.name).png")
        do {
            try resizedImage.savePng(to: url)
        } catch {
            print("ERR: \(error)")
        }
    }
    
    // Generate Contents.json
    var jsonSizes = [XcodeJson.XcodeSizesJson]()
    for size in sizes {
        jsonSizes.append(XcodeJson.XcodeSizesJson(size: size))
    }
    let fullJson = XcodeJson.XcodeFullJson(sizes: jsonSizes)
    var jsonString: String?
    do {
        let jsonData = try JSONEncoder().encode(fullJson)
        jsonString = String(data: jsonData, encoding: .utf8)
    } catch {
        print("Err: \(error)")
    }
    
    // Save Contents.json
    let jsonUrl = url.appendingPathComponent("Contents.json")
    do {
        try jsonString!.write(to: jsonUrl, atomically: false, encoding: .utf8)
    }
    catch {
        print("Err: \(error)")
    }
}

private struct XcodeJson {
    final class XcodeSizesJson: Encodable {
        var filename: String
        var size: String
        var scale: String
        var idiom: String
        var platform: String?
        var role: String?
        var subtype: String?
        
        init(size: XcodePreset.XcodeSizes) {
            self.filename = "\(size.name).png"
            self.size = "\(size.x.clean)x\(size.y.clean)"
            self.scale = "\(size.scale)x"
            self.idiom = size.idiom
            self.platform = size.platform
            self.role = size.role
            self.subtype = size.subtype
        }
    }
    
    final class XcodeFullJson: Encodable {
        var images: [XcodeSizesJson]
        var info: AppleFooter
        
        init(sizes: [XcodeSizesJson]) {
            self.images = sizes
            self.info = AppleFooter()
        }
        
        struct AppleFooter: Encodable {
            var version = 1
            var author = "xcode"
        }
    }
}
