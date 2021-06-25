//
//  XcodeAssetGenerator.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

enum XcodeAssetGenerator {
    static func save(_ image: CGImage, sizes: [XcodeSize], url: URL, prefix: String) {
        // Generate + Save Images
        for xcodeSize in sizes {
            let width  = xcodeSize.size.width * CGFloat(xcodeSize.scale)
            let height = xcodeSize.size.height * CGFloat(xcodeSize.scale)
            let destSize = NSSize(width: width, height: height)
            let resizedImage = image.resized(to: destSize, quality: .high)
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
        struct XcodeSizesJson: Encodable {
            var filename: String
            var size: String
            var scale: String
            var idiom: String
            var platform: String?
            var role: String?
            var subtype: String?

            init(xcodeSize: XcodeSize, prefix: String) {
                filename = "\(prefix)\(xcodeSize.name).png"
                size = "\(Int(xcodeSize.size.width))x\(Int(xcodeSize.size.width))"
                scale = "\(xcodeSize.scale)x"
                idiom = xcodeSize.idiom
                platform = xcodeSize.platform
                role = xcodeSize.role
                subtype = xcodeSize.subtype
            }
        }

        struct XcodeFullJson: Encodable {
            var images: [XcodeSizesJson]
            var info: AppleFooter

            init(sizes: [XcodeSizesJson]) {
                images = sizes
                info = AppleFooter()
            }

            struct AppleFooter: Encodable {
                var version = 1
                var author = "xcode"
            }
        }
    }

}
