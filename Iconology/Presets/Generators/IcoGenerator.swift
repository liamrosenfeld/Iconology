//
//  IcoGenerator.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

enum IcoGenerator {
    // MARK: - Generation
    // https://en.wikipedia.org/wiki/ICO_(file_format)
    static func saveIco(_ image: NSImage, in sizes: [ImgSetSize], at url: URL) {
        // Resize Images
        var images = [NSImage]()
        for size in sizes {
            if size.size.width >= 256 || size.size.height >= 256 {
                print("ERR: Size is too large for ICO")
                continue
            }
            images.append(image.resize(to: size.size))
        }

        // Generate Buffer
        let ico = imagesToIco(images)

        // Save
        do {
            let dir = url.appendingPathComponent("Icon.ico")
            try ico.write(to: dir)
        } catch {
            print(error)
        }
    }

    private static func imagesToIco(_ images: [NSImage]) -> Data {
        // file sections
        let header = makeHeader(imageCount: UInt16(images.count)) // top - contains general info about image
        var iconDir = Data() // middle - stores info about each image in imageData
        var imageData = Data() // bottom - actual imageData

        var offset = 0  // the location where each image will be stored
        offset += header.count
        offset += (16 * images.count) // dir size per image is always 16

        for image in images {
            let dir = getDir(of: image, withOffset: UInt32(offset))
            let data = image.PNGRepresentation!

            iconDir.append(dir)
            imageData.append(data)

            offset += data.count // add the length of the image to find where the next image will start
        }

        var final = Data()
        final.append(header)
        final.append(iconDir)
        final.append(imageData)
        return final
    }

    private static func makeHeader(imageCount count: UInt16) -> Data {
        var data = Data(count: 6)

        // reserved 0000 0000
        data[0] = 0
        data[1] = 0

        // image type 0001 0000
        data[2] = 1
        data[3] = 0

        // images in file
        data[4 ..< 6] = count.data

        return data
    }

    private static func getDir(of image: NSImage, withOffset offset: UInt32) -> Data {
        let bitmap = NSBitmapImageRep(cgImage: image.cgImage)
        let size = UInt32(image.PNGRepresentation!.count)
        let width = bitmap.size.width
        let height = bitmap.size.height
        let bpp = UInt16(bitmap.bitsPerPixel)

        var buf = Data(count: 16)
        buf[0] = UInt8(exactly: Double(width))!
        buf[1] = UInt8(exactly: Double(height))!
        buf[2] = 0 // Should be 0 if the image does not use a color palette.
        buf[3] = 0 // Reserved. Should be 0.
        buf[4 ..< 6] = Data(count: 2) // Specifies color planes. Should be 0
        buf[6 ..< 8] = bpp.data
        buf[8 ..< 12] = size.data
        buf[12 ..< 16] = offset.data

        return buf
    }

    // MARK: - Sizes
    // https://docs.microsoft.com/en-us/windows/desktop/uxguide/vis-icons
    static let winIcoSet = [
        ImgSetSize(name: "icon-16", w: 16, h: 16),
        ImgSetSize(name: "icon-24", w: 24, h: 24),
        ImgSetSize(name: "icon-32", w: 32, h: 32),
        ImgSetSize(name: "icon-48", w: 48, h: 48),
        ImgSetSize(name: "icon-64", w: 64, h: 64),
        ImgSetSize(name: "icon-256", w: 256, h: 256)
    ]

    // https://github.com/audreyr/favicon-cheat-sheet
    static let faviconIcoSet = [
        ImgSetSize(name: "favicon-16", w: 16, h: 16),
        ImgSetSize(name: "favicon-32", w: 32, h: 32),
        ImgSetSize(name: "favicon-48", w: 48, h: 48)
    ]
}

extension UnsignedInteger {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Self>.size)
    }
}
