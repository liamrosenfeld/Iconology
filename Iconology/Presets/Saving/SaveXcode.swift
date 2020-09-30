//
//  SaveXcode.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

func saveXcode(_ image: NSImage, at url: URL, in sizes: [XcodePreset.XcodeSizes], with prefix: String) {
    // Generate + Save Images
    for xcodeSize in sizes {
        let width  = xcodeSize.size.width * CGFloat(xcodeSize.scale)
        let height = xcodeSize.size.height * CGFloat(xcodeSize.scale)
        let destSize = NSSize(width: width, height: height)
        let resizedImage = image.resize(to: destSize)
        let url = url.appendingPathComponent("\(prefix)\(xcodeSize.name).png")
        do {
            try resizedImage.savePng(to: url)
        } catch {
            print("ERR: \(error)")
        }
    }

    // Generate Contents.json
    var jsonSizes = [XcodeJson.XcodeSizesJson]()
    for xcodeSize in sizes {
        jsonSizes.append(XcodeJson.XcodeSizesJson(xcodeSize: xcodeSize, prefix: prefix))
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
    } catch {
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

        init(xcodeSize: XcodePreset.XcodeSizes, prefix: String) {
            filename = "\(prefix)\(xcodeSize.name).png"
            size = "\(xcodeSize.size.width.clean)x\(xcodeSize.size.width.clean)"
            scale = "\(xcodeSize.scale)x"
            idiom = xcodeSize.idiom
            platform = xcodeSize.platform
            role = xcodeSize.role
            subtype = xcodeSize.subtype
        }
    }

    final class XcodeFullJson: Encodable {
        var images: [XcodeSizesJson]
        var info: AppleFooter

        init(sizes: [XcodeSizesJson]) {
            images = sizes
            info = AppleFooter()
        }

        //swiftlint:disable nesting
        struct AppleFooter: Encodable {
            var version = 1
            var author = "xcode"
        }
    }
}
