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
    func newImage(_ image: CGImage?) {
        guard let new = image?.copy(colorSpace: mods.colorSpace) else { return }
        origImage = new
        fullChain(size: mods.size, padding: mods.padding, quality: .high)
    }
    
    func newColorSpace(_ colorSpace: CGColorSpace) {
        guard let new = mods.origImage?.copy(colorSpace: colorSpace) else { return }
        origImage = new
        fullChain(size: mods.size, padding: mods.padding, quality: .high)
    }
    
    func fullChain(size: CGSize, padding: CGFloat, quality: CGInterpolationQuality) {
        findPadding(size: size, padding: padding)
        scaleInnerImage(mods.scale, padding: padding, quality: quality)
        findImageOrigin(shiftPercent: mods.shift, padding: padding)
        findMaskPath(rounding: mods.rounding, padding: padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        overlay()
    }
    
    func newSize(_ size: CGSize) {
        fullChain(size: size, padding: mods.padding, quality: .low)
    }
    
    func newPadding(_ padding: CGFloat) {
        fullChain(size: mods.size, padding: padding, quality: .low)
    }
    
    func newScale(scale: CGFloat) {
        scaleInnerImage(scale, padding: mods.padding, quality: .high)
        findImageOrigin(shiftPercent: mods.shift, padding: mods.padding)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    func newShift(_ shift: CGPoint) {
        findImageOrigin(shiftPercent: shift, padding: mods.padding)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    func newBackground(_ background: Background) {
        placeInFrame(background: background)
        overlay()
    }
    
    func newRounding(rounding: Rounding) {
        findMaskPath(rounding: rounding, padding: mods.padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        overlay()
    }
    
    func newShadow(attributes: ShadowAttributes) {
        makeShadow(attributes: attributes)
        overlay()
    }
    
    // MARK: - Modification Selection Finish
    func finishedPadding(_ padding: CGFloat) {
        // reapply with high interpolation quality
        scaleInnerImage(mods.scale, padding: padding, quality: .high)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    func finishedScaling(scale: CGFloat) {
        // reapply with high interpolation quality
        scaleInnerImage(scale, padding: mods.padding, quality: .high)
        placeInFrame(background: mods.background)
        overlay()
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
    
    private func overlay() {
        if let shadowImage = self.shadowImage {
            mods.finalImage = shadowImage.overlayed(self.placedImage)
        } else {
            mods.finalImage = self.placedImage
        }
    }
}
