//
//  IcnsGenerator.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

enum IcnsGenerator {
    // for info go here:
    // https://www.unix.com/man-page/osx/1/iconutil/

    static func saveIcns(_ image: CGImage, at url: URL) {
        // create temp location
        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("Icons.iconset")
        try! FileManager.default.createDirectory(at: tempUrl, withIntermediateDirectories: true, attributes: nil)

        // create with iconutil
        for size in ImgSetSizes.macIconset {
            let resizedImage = image.resized(to: size.size, quality: .high)
            let pngUrl = tempUrl.appendingPathComponent("\(size.name).png")
            do {
                try resizedImage.savePng(to: pngUrl)
            } catch {
                print("ERR: \(error)")
            }
        }
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
