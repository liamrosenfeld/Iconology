//
//  ImageModifier.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/8/21.
//  Copyright © 2021 Liam Rosenfeld. All rights reserved.
//

import AppKit
import Combine

class ImageModifier: ObservableObject {
    // MARK: - Modifications
    var mods: ImageModifications
    private var subscribers = Set<AnyCancellable>()

    // MARK: - Intermediate Storage
    var size: CGSize = CGSize(width: 1, height: 1)
    private var innerSize: CGSize = .zero
    
    private var imageOrigin: CGPoint = .zero
    private var maskPath: CGPath?
    
    private var scaledImage: CGImage!
    private var placedImage: CGImage!
    private var shadowImage: CGImage?
    
    // MARK: - In and Out
    public var origImage: CGImage? { didSet { fullChain(size: mods.size, padding: mods.padding, quality: .high) } }
    @Published private(set) var finalImage: CGImage?
    
    // MARK: - Modification Change Reactions
    private func fullChain(size: CGSize, padding: CGFloat, quality: CGInterpolationQuality) {
        findPadding(size: size, padding: padding)
        scaleInnerImage(mods.scale, padding: padding, quality: quality)
        findImageOrigin(shiftPercent: mods.shift, padding: padding)
        findMaskPath(rounding: mods.rounding, padding: padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        overlay()
    }
    
    private func newSize(_ size: CGSize) {
        self.size = size // save here so that full chain has the correct value
        fullChain(size: size, padding: mods.padding, quality: .low)
    }
    
    private func newPadding(_ padding: CGFloat) {
        fullChain(size: mods.size, padding: padding, quality: .low)
    }
    
    private func newScale(scale: CGFloat) {
        scaleInnerImage(scale, padding: mods.padding, quality: .high)
        findImageOrigin(shiftPercent: mods.shift, padding: mods.padding)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    private func newShift(_ shift: CGPoint) {
        findImageOrigin(shiftPercent: shift, padding: mods.padding)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    private func newBackground(_ background: Background) {
        placeInFrame(background: background)
        overlay()
    }
    
    private func newRounding(rounding: Rounding) {
        findMaskPath(rounding: rounding, padding: mods.padding)
        // TODO: async PIF and shadow
        placeInFrame(background: mods.background)
        makeShadow(attributes: mods.shadow)
        overlay()
    }
    
    private func newShadow(attributes: ShadowAttributes) {
        makeShadow(attributes: attributes)
        overlay()
    }
    
    // MARK: - Modification Selection Finish
    private func finishedPadding(_ padding: CGFloat) {
        // reapply with high interpolation quality
        scaleInnerImage(mods.scale, padding: padding, quality: .high)
        placeInFrame(background: mods.background)
        overlay()
    }
    
    private func finishedScaling(scale: CGFloat) {
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
        scaledImage = origImage!.scaled(by: adjustedScale, quality: quality)
    }
    
    private func findImageOrigin(shiftPercent: CGPoint, padding: CGFloat) {
        // get origins inner frame and image inside the frame
        let innerFrameOrigin = CGPoint(
            x: (padding / 200) * size.width,
            y: (padding / 200) * size.height
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
            x: (padding / 200) * size.width,
            y: (padding / 200) * size.height
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
            frame: size,
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
        shadowImage = maskPath.makeShadow(frame: size, attributes: attributes)
    }
    
    private func overlay() {
        if let shadowImage = shadowImage {
            finalImage = shadowImage.overlayed(placedImage)
        } else {
            finalImage = placedImage
        }
    }

    // MARK: - Init
    init() {
        self.mods = ImageModifications()
    }
    
    init(image: CGImage) {
        origImage = image
        
        self.mods = ImageModifications()

        if image.size != .zero {
            fullChain(size: size, padding: mods.padding, quality: .high)
        }
    }

    func observeChanges() {
        // share pubs that need both immediate and after
        let scalePub = mods.$scale.share()
        let paddingPub = mods.$padding.share()
        
        // reacting to immediate changes
        mods.$size
            .sink(receiveValue: newSize)
            .store(in: &subscribers)
        scalePub
            .sink(receiveValue: newScale)
            .store(in: &subscribers)
        mods.$shift
            .sink(receiveValue: newShift)
            .store(in: &subscribers)
        mods.$background
            .sink(receiveValue: newBackground)
            .store(in: &subscribers)
        mods.$rounding
            .sink(receiveValue: newRounding)
            .store(in: &subscribers)
        paddingPub
            .sink(receiveValue: newPadding)
            .store(in: &subscribers)
        mods.$shadow
            .sink(receiveValue: newShadow)
            .store(in: &subscribers)
        
        // react to finished selecting
        let debounceTime: RunLoop.SchedulerTimeType.Stride = .seconds(0.2)
        scalePub
            .debounce(for: debounceTime, scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: finishedScaling)
            .store(in: &subscribers)
        paddingPub
            .debounce(for: debounceTime, scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: finishedPadding)
            .store(in: &subscribers)
    }
}

