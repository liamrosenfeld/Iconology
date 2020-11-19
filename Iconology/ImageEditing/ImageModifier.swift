//
//  ImageModifier.swift
//  Iconology
//
//  Created by Liam Rosenfeld on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class ImageModifier {
    // MARK: - Modification Properties

    public var aspect: NSSize { didSet { applyAspect() } }
    public var scale: CGFloat { didSet { applyScale() } }
    public var shift: CGPoint { didSet { applyShift() } }
    public var background: NSColor? { didSet { applyBackground() } }
    public var rounding: CGFloat { didSet { applyRound() } }
    public var padding: CGFloat { didSet { applyRound() } }

    // MARK: - Chain Storage

    public var origImage: NSImage { didSet { fullChain() } }
    private var appliedAspect: NSSize = .zero
    private var scaledImage = NSImage()
    private var placedImage = NSImage()
    private var backedImage = NSImage()
    private var roundedImage = NSImage()

    // MARK: - Output

    private var after: ((NSImage) -> Void)?
    public var image = NSImage() {
        didSet {
            if let after = after {
                after(image)
            }
        }
    }

    // MARK: - Chain Apply

    private func fullChain() {
        appliedAspect = origImage.findFrame(aspect: aspect)
        applyScale()
    }

    private func applyAspect() {
        appliedAspect = origImage.findFrame(aspect: aspect)
        applyShift()
    }

    private func applyScale() {
        scaledImage = origImage.scale(by: scale)
        applyShift()
    }

    private func applyShift() {
        placedImage = scaledImage.placeInFrame(appliedAspect, at: shift)
        applyBackground()
    }

    private func applyBackground() {
        if let color = background {
            backedImage = placedImage.addBackground(of: color)
        } else {
            backedImage = placedImage
        }
        applyRound()
    }

    private func applyRound() {
        if rounding != 0 {
            roundedImage = backedImage.round(by: rounding)
        } else {
            roundedImage = backedImage
        }
        applyPadding()
    }

    private func applyPadding() {
        if padding != 0 {
            image = roundedImage.pad(by: padding)
        } else {
            image = roundedImage
        }
    }

    // MARK: - Init

    init(image: NSImage, after: ((NSImage) -> Void)? = nil) {
        // Default Images
        origImage = image
        self.image = image

        // Default Properties
        aspect = NSSize(width: 1, height: 1)
        scale = 100
        shift = .zero
        background = nil
        rounding = 0
        padding = 0

        self.after = after

        // Initial Chain
        if image.size != .zero {
            fullChain()
        }
    }
}
