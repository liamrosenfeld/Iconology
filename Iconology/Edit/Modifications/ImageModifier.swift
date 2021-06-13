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
    // saving intermediate images it prevents redoing identical work
    private var appliedAspect: NSSize = .zero
    private var scaledImage = NSImage()
    private var placedImage = NSImage()
    private var backedImage = NSImage()
    private var roundedImage = NSImage()

    // MARK: - In and Out
    public var origImage: NSImage { didSet { fullChain() } }
    @Published private(set) var finalImage: NSImage

    // MARK: - Chain Apply
    private func fullChain() {
        appliedAspect = origImage.findFrame(aspect: mods.aspect)
        applyScale(mods.scale)
    }

    private func applyAspect(_ aspect: CGSize) {
        appliedAspect = origImage.findFrame(aspect: aspect)
        applyShift(mods.shift)
    }

    private func applyScale(_ scale: CGFloat) {
        scaledImage = origImage.scale(by: scale)
        applyShift(mods.shift)
    }

    private func applyShift(_ shift: CGPoint) {
        placedImage = scaledImage.placeInFrame(appliedAspect, at: shift)
        applyBackground(mods.background)
    }

    private func applyBackground(_ background: CGColor) {
        if mods.useBackground {
            backedImage = placedImage.addBackground(of: background)
        } else {
            backedImage = placedImage
        }
        applyRounding(mods.rounding)
    }

    private func toggledBackground(to enabled: Bool) {
        if enabled {
            backedImage = placedImage.addBackground(of: mods.background)
        } else {
            backedImage = placedImage
        }
        applyRounding(mods.rounding)
    }

    private func applyRounding(_ rounding: CGFloat) {
        if rounding != 0 {
            roundedImage = backedImage.round(by: rounding)
        } else {
            roundedImage = backedImage
        }
        applyPadding(mods.padding)
    }

    private func applyPadding(_ padding: CGFloat) {
        if padding != 0 {
            finalImage = roundedImage.pad(by: padding)
        } else {
            finalImage = roundedImage
        }
    }

    // MARK: - Init
    init(image: NSImage) {
        origImage = image
        finalImage = image

        self.mods = ImageModifications()

        if image.size != .zero {
            fullChain()
        }
    }

    func observeChanges() {
        mods.$aspect
            .sink(receiveValue: applyAspect)
            .store(in: &subscribers)
        mods.$scale
            .sink(receiveValue: applyScale)
            .store(in: &subscribers)
        mods.$shift
            .sink(receiveValue: applyShift)
            .store(in: &subscribers)
        mods.$background
            .sink(receiveValue: applyBackground)
            .store(in: &subscribers)
        mods.$useBackground
            .sink(receiveValue: toggledBackground)
            .store(in: &subscribers)
        mods.$rounding
            .sink(receiveValue: applyRounding)
            .store(in: &subscribers)
        mods.$padding
            .sink(receiveValue: applyPadding)
            .store(in: &subscribers)
    }
}
