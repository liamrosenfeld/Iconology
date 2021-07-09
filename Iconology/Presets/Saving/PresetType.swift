//
//  PresetType.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 7/4/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import Foundation

enum PresetType: Hashable, Codable {
    case xcodeAsset(sizes: [XcodeIconSize], folderName: String)
    case imgSet([ImgSetSize])
    case png
    case icns
    case ico([ImgSetSize])
    
    // MARK: - Saving
    /// Save the image dependent on preset type
    /// - Returns:
    /// URL where the folder/file was saved. Nil if save is canceled
    func save(_ image: CGImage) -> URL? {
        switch self {
        case .xcodeAsset(let sizes, let folderName):
            return Self.saveXcode(image: image, sizes: sizes, folderName: folderName)
        case .imgSet(let sizes):
            return Self.saveImgSet(image: image, sizes: sizes)
        case .png:
            guard let fileUrl = SavePanel.file(type: .png) else { return nil }
            try! image.savePng(to: fileUrl)
            return fileUrl
        case .icns:
            guard let fileUrl = SavePanel.file(type: .icns) else { return nil }
            IcnsGenerator.saveIcns(image, at: fileUrl)
            return fileUrl
        case .ico(let sizes):
            guard let fileUrl = SavePanel.file(type: .ico) else { return nil }
            IcoGenerator.saveIco(image, in: sizes, at: fileUrl)
            return fileUrl
        }
    }
    
    private static func saveXcode(image: CGImage, sizes: [XcodeIconSize], folderName: String) -> URL? {
        // get where to save
        guard let (parentUrl, prefix) = SavePanel.folderAndPrefix() else { return nil }
        let saveUrl = parentUrl.appendingPathComponent(folderName)
        
        // save files there
        try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
        XcodeAssetGenerator.save(image, sizes: sizes, url: saveUrl, prefix: prefix)
        
        return saveUrl
    }
    
    private static func saveImgSet(image: CGImage, sizes: [ImgSetSize]) -> URL? {
        // get where to save
        guard let (parentUrl, prefix) = SavePanel.folderAndPrefix() else { return nil }
        let saveUrl = parentUrl.appendingPathComponent("Icons")
        
        // save files there
        try! FileManager.default.createDirectory(at: saveUrl, withIntermediateDirectories: true, attributes: nil)
        ImgSetGenerator.savePngs(image, at: saveUrl, with: prefix, in: sizes)
        
        return saveUrl
    }
    
    // MARK: - Editing
    var imgSizes: [ImgSetSize] {
        get {
            switch self {
            case .imgSet(let sizes):
                return sizes
            default:
                print("WARN: getting imgSizes when not supposed to")
                return []
            }
        }
        set {
            switch self {
            case .imgSet:
                self = .imgSet(newValue)
            default:
                print("WARN: setting gradient when not supposed to")
            }
        }
    }
}
