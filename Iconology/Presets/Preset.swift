//
//  Preset.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 12/21/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import AppKit

struct Preset: Hashable, Codable {
    var name: String
    var type: PresetType
    var aspect: CGSize
    var useModifications: EnabledModifications

    func save(_ image: CGImage, at url: URL, with prefix: String) -> URL {
        switch type {
        case .xcodeAsset(let sizes, let folderName):
            let saveUrl = url.appendingPathComponent(folderName)
            try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
            XcodeAssetGenerator.save(image, sizes: sizes, url: saveUrl, prefix: prefix)
            return saveUrl
        case .imgSet(let sizes):
            let saveUrl = url.appendingPathComponent("Icons")
            try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
            savePngs(image, at: saveUrl, with: prefix, in: sizes)
            return saveUrl
        case .png:
            let fileUrl = url.appendingPathComponent("Icon.png")
            try! image.savePng(to: fileUrl)
            return fileUrl
        case .icns:
            IcnsGenerator.saveIcns(image, at: url)
            return url.appendingPathComponent("Icon.icns")
        case .ico(let sizes):
            IcoGenerator.saveIco(image, in: sizes, at: url)
            return url.appendingPathComponent("Icon.ico")
        }
    }

    private func savePngs(_ image: CGImage, at url: URL, with prefix: String, in sizes: [ImgSetSize]) {
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

    init(name: String, type: PresetType, aspect: NSSize, useModifications: EnabledModifications) {
        self.name = name
        self.type = type
        self.aspect = aspect
        self.useModifications = useModifications
    }

    init(name: String, type: PresetType, useModifications: EnabledModifications) {
        self.name = name
        self.type = type
        self.aspect = CGSize(width: 1, height: 1)
        self.useModifications = useModifications
    }
}

enum PresetType: Hashable, Codable {
    case xcodeAsset(sizes: [XcodeSize], folderName: String)
    case imgSet([ImgSetSize])
    case png
    case icns
    case ico([ImgSetSize])
}

struct EnabledModifications: Hashable, Codable {
    var background: Bool
    var scale: Bool
    var shift: Bool
    var round: Bool
    var padding: Bool
    var prefix: Bool

    init(background: Bool, scale: Bool, shift: Bool, round: Bool, padding: Bool, prefix: Bool) {
        self.background = background
        self.scale = scale
        self.shift = shift
        self.round = round
        self.padding = padding
        self.prefix = prefix
    }

    static func all() -> Self {
        EnabledModifications(
            background: true,
            scale: true,
            shift: true,
            round: true,
            padding: true,
            prefix: true
        )
    }

    static func limited() -> Self {
        EnabledModifications(
            background: true,
            scale: true,
            shift: true,
            round: false,
            padding: false,
            prefix: true
        )
    }

    static func noPrefix() -> Self {
        EnabledModifications(
            background: true,
            scale: true,
            shift: true,
            round: true,
            padding: true,
            prefix: false
        )
    }
}
