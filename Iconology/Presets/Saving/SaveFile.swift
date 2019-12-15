//
//  SaveFile.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

func saveFile(_ image: NSImage, at url: URL, as type: FilePreset.Filetype) {
    switch type {
    case .png:
        savePng(image, named: "Icon", at: url)
    case .icns:
        IcnsGenerator.saveIcns(image, at: url)
    case let .ico(sizes):
        IcoGenerator.saveIco(image, in: sizes, at: url)
    }
}

private struct IcoGenerator {
    // for info go here:
    // https://en.wikipedia.org/wiki/ICO_(file_format)

    static func saveIco(_ image: NSImage, in sizes: [ImgSetPreset.ImgSetSize], at url: URL) {
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
        let header = makeHeader(imageCount: UInt16(images.count)) // top - countains general info about image
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
}

private struct IcnsGenerator {
    // for info go here:
    // https://www.unix.com/man-page/osx/1/iconutil/

    static func saveIcns(_ image: NSImage, at url: URL) {
        // create temp location
        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("Icons.iconset")
        FileHandler.createFolder(directory: tempUrl)

        // create with iconutil
        savePngs(image, at: tempUrl, with: "", in: macIconset)
        iconUtil(in: tempUrl, out: url)

        // tear down
        do {
            try FileManager.default.removeItem(at: tempUrl)
        } catch {
            print("ERR: \(error)")
        }
    }

    private static func iconUtil(in input: URL, out output: URL) {
        // get save location
        let output = output.appendingPathComponent("Icon.icns")

        // Create a new process to run /usr/bin/iconutil
        let iconUtil = Process()

        // Configure Task.
        iconUtil.launchPath = "/usr/bin/iconutil"
        iconUtil.arguments = ["--convert", "icns", input.path, "-o", output.path]

        // lauch task
        iconUtil.launch()
        iconUtil.waitUntilExit()
    }
}

extension UnsignedInteger {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<Self>.size)
    }
}
