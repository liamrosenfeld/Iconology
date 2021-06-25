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
    private var outerSize: NSSize = .zero
    private var innerSize: NSSize = .zero
    private var scaledImage: CGImage!
    
    // MARK: - In and Out
    public var origImage: CGImage { didSet { fullChain() } }
    @Published private(set) var finalImage: CGImage
    
    // MARK: - Modification Change Reactions
    private func fullChain() {
        findSizes(
            aspect: mods.aspect,
            padding: mods.padding
        )
        scaleInnerImage(
            mods.scale,
            padding: mods.padding,
            quality: .high
        )
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newAspect(_ aspect: CGSize) {
        findSizes(
            aspect: aspect,
            padding: mods.padding
        )
        scaleInnerImage(
            mods.scale,
            padding: mods.padding,
            quality: .high
        )
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newPadding(_ padding: CGFloat) {
        findSizes(
            aspect: mods.aspect,
            padding: padding
        )
        scaleInnerImage(
            mods.scale,
            padding: padding,
            quality: .low
        )
        assemble(
            shiftPercent: mods.shift,
            padding: padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newScale(scale: CGFloat) {
        scaleInnerImage(
            scale,
            padding: mods.padding,
            quality: .low
        )
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newShift(_ shift: CGPoint) {
        assemble(
            shiftPercent: shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func toggledBackground(to enabled: Bool) {
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: enabled ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newBackground(_ background: CGColor) {
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? background : nil,
            rounding: mods.rounding
        )
    }
    
    private func newRounding(rounding: CGFloat) {
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: rounding
        )
    }
    
    // MARK: - Modification Selection Finish
    private func finishedPadding(_ padding: CGFloat) {
        // reapply with high interpolation quality
        scaleInnerImage(
            mods.scale,
            padding: padding,
            quality: .high
        )
        assemble(
            shiftPercent: mods.shift,
            padding: padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func finishedScaling(scale: CGFloat) {
        // reapply with high interpolation quality
        scaleInnerImage(
            scale,
            padding: mods.padding,
            quality: .high
        )
        assemble(
            shiftPercent: mods.shift,
            padding: mods.padding,
            background: mods.useBackground ? mods.background : nil,
            rounding: mods.rounding
        )
    }
    
    private func finishedShifting(_ shift: CGPoint) {
        // TODO: cache shifted image on blank background
    }
    
    private func finishedBackground(_: CGColor) {
        // TODO: cache shifted image with background
    }
    
    // MARK: - Image Editing
    private func findSizes(aspect: CGSize, padding: CGFloat) {
        outerSize = origImage.size.findFrame(aspect: aspect)
        
        let appliedPadding = CGSize(
            width: (padding / 100) * outerSize.width,
            height: (padding / 100) * outerSize.height
        )
        innerSize = outerSize - appliedPadding
    }
    
    private func scaleInnerImage(_ scale: CGFloat, padding: CGFloat, quality: CGInterpolationQuality) {
        let adjustedScale = scale * (1 - (padding / 100))
        scaledImage = origImage.scaled(by: adjustedScale, quality: quality)
    }
    
    private func assemble(shiftPercent: CGPoint, padding: CGFloat, background: CGColor?, rounding: CGFloat) {
        // get shifted origin of the inner frame
        let innerFrameOrigin = CGPoint(
            x: (padding / 200) * outerSize.width,
            y: (padding / 200) * outerSize.height
        )
        let imageOriginWithinInnerFrame = CGPoint(
            x: (innerSize.width / 2) - (CGFloat(scaledImage.width) / 2),
            y: (innerSize.height / 2) - (CGFloat(scaledImage.height) / 2)
        )
        let shift = CGPoint(
            x: (shiftPercent.x / 100) * innerSize.width,
            y: (shiftPercent.y / 100) * innerSize.height
        )
        let shiftedInnerOrigin = innerFrameOrigin + imageOriginWithinInnerFrame + shift
        
        // get rounding path
        let roundingPath = getMaskPath(rounding: rounding, innerOrigin: innerFrameOrigin)
        
        finalImage = scaledImage.placedInFrame(
            frame: outerSize,
            shift: shiftedInnerOrigin,
            background: background,
            mask: roundingPath
        )
    }
    
    private func getMaskPath(rounding: CGFloat, innerOrigin: CGPoint) -> CGPath? {
        if rounding == 0 {
            if innerOrigin == .zero {
                // in this case there is no reason to apply a mask
                return nil
            } else {
                let innerRect = CGRect(origin: innerOrigin, size: innerSize)
                return CGPath(rect: innerRect, transform: nil)
            }
        } else {
            let innerRect = CGRect(origin: innerOrigin, size: innerSize)
            return .roundedRect(rect: innerRect, roundingPercent: rounding)
        }
    }

    // MARK: - Init
    init(image: CGImage) {
        origImage = image
        finalImage = image

        self.mods = ImageModifications()

        if image.size != .zero {
            fullChain()
        }
    }

    func observeChanges() {
        // share pubs that need both immediate and after
        let scalePub = mods.$scale.share()
        let paddingPub = mods.$padding.share()
        
        // reacting to immediate changes
        mods.$aspect
            .sink(receiveValue: newAspect)
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
        mods.$useBackground
            .sink(receiveValue: toggledBackground)
            .store(in: &subscribers)
        mods.$rounding
            .sink(receiveValue: newRounding)
            .store(in: &subscribers)
        paddingPub
            .sink(receiveValue: newPadding)
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
