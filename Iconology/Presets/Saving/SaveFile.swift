//
//  SaveFile.swift
//  Iconology
//
//  Created by Liam on 12/23/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

func saveFile(_ image: NSImage, at url: URL, as type: FilePreset.Filetype) {
    switch type {
    case .icns:
        saveIcns(image, in: macIconset, at: url)
    case .ico:
        saveIco(image, in: macIconset, at: url)
    }
}

private func saveIco(_ image: NSImage, in sizes: [ImgSetPreset.ImgSetSize], at url: URL) {
    // Make ICNS
    let tempUrl = FileManager.default.temporaryDirectory
    saveIcns(image, in: macIconset, at: tempUrl)
    
    // Convert to ICO
    let icnsPath = tempUrl.appendingPathComponent("Icon.icns")
    let icoPath = url.appendingPathComponent("Icon.ico")
    try? FileManager.default.removeItem(at: icoPath)
    do {
        try FileManager.default.moveItem(at: icnsPath, to: icoPath)
    } catch {
        print("ERR: \(error)")
    }
}

private func saveIcns(_ image: NSImage, in sizes: [ImgSetPreset.ImgSetSize], at url: URL) {
    let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("Icons.iconset")
    FileHandler.createFolder(directory: tempUrl)
    savePng(image, at: tempUrl, with: "", in: sizes)
    iconUtil(in: tempUrl, out: url)
}

private func iconUtil(in input: URL, out output: URL) {
    let output = output.appendingPathComponent("Icon.icns")
    // Create a new process to run /usr/bin/iconutil
    let iconUtil = Process()
    // Configure and launch the Task.
    iconUtil.launchPath = "/usr/bin/iconutil"
    iconUtil.arguments = ["-c", "icns", input.path, "-o", output.path]
    iconUtil.launch()
    iconUtil.waitUntilExit()
}
