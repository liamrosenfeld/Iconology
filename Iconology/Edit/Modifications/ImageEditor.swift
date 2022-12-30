//
//  ImageEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/25/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import Foundation
import CoreGraphics

class ImageEditor {
    unowned var mods: ImageModifier
    
    init(_ mods: ImageModifier) {
        self.mods = mods
    }
    
    // MARK: - Intermediate Storage
    private var origImage: CGImage!
    
    private var innerSize: CGSize = .zero
    
    private var imageOrigin: CGPoint = .zero
    private var maskPath: CGPath?
    
    private var scaledImage: CGImage!
    private var placedImage: CGImage!
    private var shadowImage: CGImage?
    
    // MARK: - Modification Change Reactions
    func newImage(_ image: CGImage?) -> CGImage? {
        guard let new = image?.copy(colorSpace: mods.colorSpace) else { return nil }
        origImage = new
        return fullChain(size: mods.size, padding: mods.padding, quality: .high)
    }
    
    func newColorSpace(_ colorSpace: CGColorSpace) -> CGImage? {
        guard let new = mods.origImage?.copy(colorSpace: colorSpace) else { return nil }
        origImage = new
        return fullChain(size: mods.size, padding: mods.padding, quality: .high)
    }
    
    func fullChain(size: CGSize, padding: CGFloat, quality: CGInterpolationQuality) -> CGImage {
        findPadding(size: size, padding: padding)
        scaleInnerImage(mods.scale, padding: padding, quality: quality)
        findImageOrigin(shiftPercent: mods.shift, padding: padding)
        findMaskPath(rounding: mods.rounding, padding: padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        return overlay()
    }
    
    func newSize(_ size: CGSize) -> CGImage {
        return fullChain(size: size, padding: mods.padding, quality: .low)
    }
    
    func newPadding(_ padding: CGFloat) -> CGImage {
        return fullChain(size: mods.size, padding: padding, quality: .low)
    }
    
    func newScale(scale: CGFloat) -> CGImage {
        scaleInnerImage(scale, padding: mods.padding, quality: .high)
        findImageOrigin(shiftPercent: mods.shift, padding: mods.padding)
        placeInFrame(background: mods.background)
        return overlay()
    }
    
    func newShift(_ shift: CGPoint) -> CGImage {
        findImageOrigin(shiftPercent: shift, padding: mods.padding) // could move this into the inside of place in frame
        placeInFrame(background: mods.background)
        return overlay()
    }
    
    func newBackground(_ background: Background) -> CGImage {
        placeInFrame(background: background)
        return overlay()
    }
    
    func newRounding(rounding: Rounding) -> CGImage {
        findMaskPath(rounding: rounding, padding: mods.padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        return overlay()
    }
    
    func newShadow(attributes: ShadowAttributes) -> CGImage {
        makeShadow(attributes: attributes)
        return overlay()
    }
    
    // MARK: - Modification Selection Finish
    func finishedPadding(_ padding: CGFloat) -> CGImage {
        // reapply with high interpolation quality
        scaleInnerImage(mods.scale, padding: padding, quality: .high)
        placeInFrame(background: mods.background)
        return overlay()
    }
    
    func finishedScaling(scale: CGFloat) -> CGImage {
        // reapply with high interpolation quality
        scaleInnerImage(scale, padding: mods.padding, quality: .high)
        placeInFrame(background: mods.background)
        return overlay()
    }
    
    // MARK: - Image Editing
    private func findPadding(size: CGSize, padding: CGFloat) {
        let appliedPadding = CGSize(
            width: (padding / 100) * size.width,
            height: (padding / 100) * size.height
        )
        innerSize = size - appliedPadding
    }
    
    private func scaleInnerImage(_ scale: CGFloat, padding: CGFloat, quality: CGInterpolationQuality) {
        let adjustedScale = scale * (1 - (padding / 100))
        scaledImage = origImage.scaled(by: adjustedScale, quality: quality)
    }
    
    private func findImageOrigin(shiftPercent: CGPoint, padding: CGFloat) {
        // get origins inner frame and image inside the frame
        let innerFrameOrigin = CGPoint(
            x: (padding / 200) * mods.size.width,
            y: (padding / 200) * mods.size.height
        )
        let centeredImageOriginWithinInnerFrame = CGPoint(
            x: (innerSize.width / 2) - (CGFloat(scaledImage.width) / 2),
            y: (innerSize.height / 2) - (CGFloat(scaledImage.height) / 2)
        )
        let shift = CGPoint(
            x: (shiftPercent.x / 100) * innerSize.width,
            y: (shiftPercent.y / 100) * innerSize.height
        )
        
        imageOrigin = innerFrameOrigin + centeredImageOriginWithinInnerFrame + shift
    }
    
    private func findMaskPath(rounding: Rounding, padding: CGFloat) {
        let innerOrigin = CGPoint(
            x: (padding / 200) * mods.size.width,
            y: (padding / 200) * mods.size.height
        )
        if rounding.percent == 0 {
            if innerOrigin == .zero {
                // in this case there is no reason to apply a mask
                maskPath = nil
            } else {
                let innerRect = CGRect(origin: innerOrigin, size: innerSize)
                maskPath = CGPath(rect: innerRect, transform: nil)
            }
        } else {
            let innerRect = CGRect(origin: innerOrigin, size: innerSize)
            switch rounding.style {
            case .circular:
                maskPath = .circularRoundedRect(rect: innerRect, roundingPercent: rounding.percent)
            case .continuous:
                maskPath = .continuousRoundedRect(rect: innerRect, roundingPercent: rounding.percent)
            case .squircle:
                maskPath = .squircle(rect: innerRect, roundingPercent: rounding.percent)
            }
            
        }
    }
    
    private func placeInFrame(background: Background) {
        placedImage = scaledImage.placedInFrame(
            frame: mods.size,
            imageOrigin: imageOrigin,
            background: background,
            mask: maskPath
        )
    }
    
    private func makeShadow(attributes: ShadowAttributes) {
        guard let maskPath = maskPath,
              attributes.opacity != 0,
              mods.padding != 0 || mods.rounding.percent != 0
        else {
            shadowImage = nil
            return
        }
        shadowImage = CGImage.makeShadow(path: maskPath, frame: mods.size, attributes: attributes, colorSpace: mods.colorSpace)
    }
    
    private func overlay() -> CGImage {
        if let shadowImage = self.shadowImage {
            return shadowImage.overlayed(self.placedImage)
        } else {
            return self.placedImage
        }
    }
}