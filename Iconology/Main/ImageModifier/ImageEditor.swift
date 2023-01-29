//
//  ImageEditor.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 5/25/22.
//  Copyright © 2022 Liam Rosenfeld. All rights reserved.
//

import Foundation
import CoreGraphics

struct ImageModifications {
    var size: CGSize
    var scale: CGFloat
    var shift: CGPoint
    var background: Background
    var rounding: Rounding
    var padding: CGFloat
    var shadow: ShadowAttributes
    var colorSpace: CGColorSpace
}

class ImageEditor {
    // MARK: - Intermediate Storage
    private var origImage: CGImage!
    
    private var innerSize: CGSize = .zero
    
    private var maskPath: CGPath?
    
    private var scaledImage: CGImage?
    private var placedImage: CGImage!
    private var shadowImage: CGImage?
    
    // MARK: - Modification Change Reactions
    func newImage(_ image: CGImage?, mods: ImageModifications) -> CGImage? {
        guard let new = image?.copy(colorSpace: mods.colorSpace) else { return nil }
        origImage = new
        return fullChain(mods: mods, quality: .high)
    }
    
    func newSize(mods: ImageModifications) -> CGImage {
        return fullChain(mods: mods, quality: .high)
    }
        
    func fullChain(mods: ImageModifications, quality: CGInterpolationQuality) -> CGImage {
        findPadding(size: mods.size, padding: mods.padding)
        scaleInnerImage(mods.scale, padding: mods.padding, quality: quality)
        findMaskPath(rounding: mods.rounding, padding: mods.padding, frame: mods.size)
        placeInFrame(mods: mods)
        makeShadow(mods: mods)
        return overlay()
    }
    
    func newPadding(mods: ImageModifications) -> CGImage {
        return fullChain(mods: mods, quality: .low)
    }
    
    func newScale(mods: ImageModifications) -> CGImage {
        scaleInnerImage(mods.scale, padding: mods.padding, quality: .low)
        placeInFrame(mods: mods)
        return overlay()
    }
    
    func newShift(mods: ImageModifications) -> CGImage {
        placeInFrame(mods: mods)
        return overlay()
    }
    
    func newBackground(mods: ImageModifications) -> CGImage {
        placeInFrame(mods: mods)
        return overlay()
    }
    
    func newRounding(mods: ImageModifications) -> CGImage {
        findMaskPath(rounding: mods.rounding, padding: mods.padding, frame: mods.size)
        placeInFrame(mods: mods)
        makeShadow(mods: mods)
        return overlay()
    }
    
    func newShadow(mods: ImageModifications) -> CGImage {
        makeShadow(mods: mods)
        return overlay()
    }
    
    // MARK: - Modification Selection Finish
    func finishedPadding(mods: ImageModifications) -> CGImage {
        // reapply with high interpolation quality
        scaleInnerImage(mods.scale, padding: mods.padding, quality: .high)
        placeInFrame(mods: mods)
        return overlay()
    }
    
    func finishedScaling(mods: ImageModifications) -> CGImage {
        // reapply with high interpolation quality
        scaleInnerImage(mods.scale, padding: mods.padding, quality: .high)
        placeInFrame(mods: mods)
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
    
    private func findImageOrigin(imgSize: CGSize, mods: ImageModifications) -> CGPoint {
        // get origins inner frame and image inside the frame
        let innerFrameOrigin = CGPoint(
            x: (mods.padding / 200) * mods.size.width,
            y: (mods.padding / 200) * mods.size.height
        )
        let centeredImageOriginWithinInnerFrame = CGPoint(
            x: (innerSize.width / 2) - (CGFloat(imgSize.width) / 2),
            y: (innerSize.height / 2) - (CGFloat(imgSize.height) / 2)
        )
        let shift = CGPoint(
            x: (mods.shift.x / 100) * innerSize.width,
            y: (mods.shift.y / 100) * innerSize.height
        )
        
        return innerFrameOrigin + centeredImageOriginWithinInnerFrame + shift
    }
    
    private func findMaskPath(rounding: Rounding, padding: CGFloat, frame: CGSize) {
        let innerOrigin = CGPoint(
            x: (padding / 200) * frame.width,
            y: (padding / 200) * frame.height
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
    
    private func placeInFrame(mods: ImageModifications) {
        if let scaledImage {
            let imageOrigin = findImageOrigin(
                imgSize: scaledImage.size,
                mods: mods
            )
            placedImage = scaledImage.placedInFrame(
                frame: mods.size,
                imageOrigin: imageOrigin,
                background: mods.background,
                mask: maskPath
            )
        } else {
            placedImage = CGImage.justBackground(
                frame: mods.size,
                background: mods.background,
                mask: maskPath,
                colorSpace: mods.colorSpace
            )
        }
    }
    
    private func makeShadow(mods: ImageModifications) {
        guard let maskPath = maskPath,
              mods.shadow.opacity != 0,
              mods.padding != 0 || mods.rounding.percent != 0
        else {
            shadowImage = nil
            return
        }
        shadowImage = CGImage.makeShadow(
            path: maskPath,
            frame: mods.size,
            attributes: mods.shadow,
            colorSpace: mods.colorSpace
        )
    }
    
    private func overlay() -> CGImage {
        if let shadowImage = self.shadowImage {
            return shadowImage.overlayed(self.placedImage)
        } else {
            return self.placedImage
        }
    }
}
