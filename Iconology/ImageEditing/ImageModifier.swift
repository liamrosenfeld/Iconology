//
//  ImageModifier.swift
//  Iconology
//
//  Created by Liam on 6/12/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class ImageModifier {
    // MARK: - Modification Properties
    public var aspect: NSSize { didSet { applyAspect() } }
    public var scale: CGFloat { didSet { applyScale()  } }
    public var shift: CGPoint { didSet { applyShift()  } }
    public var background: NSColor? { didSet { applyBackground() } }
    public var rounding: CGFloat { didSet { applyRound() } }
    
    // MARK: - Chain Storage
    public  var origImage: NSImage { didSet { fullChain() } }
    private var appliedAspect: NSSize = .zero
    private var scaledImage = NSImage()
    private var placedImage = NSImage()
    private var withBack    = NSImage()
    
    // MARK: - Output
    private var after: ((NSImage) -> ())?
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
        placedImage =  scaledImage.placeInFrame(appliedAspect, at: shift)
        applyBackground()
    }
    
    private func applyBackground() {
        if let color = background {
            withBack = placedImage.addBackground(of: color)
        } else {
            withBack = placedImage
        }
        applyRound()
    }
    
    private func applyRound() {
        if rounding != 0 {
            image = withBack.round(by: rounding)
        } else {
            image = withBack
        }
    }
    
    // MARK: - Init
    init(image: NSImage, after: ((NSImage) -> ())? = nil) {
        // Default Images
        self.origImage = image
        self.image = image
        
        // Default Properties
        self.aspect = NSSize(width: 1, height: 1)
        self.scale = 1
        self.shift = .zero
        self.background = nil
        self.rounding = 0
        
        self.after = after
        
        // Initial Chain
        if image.size != .zero {
            fullChain()
        }
    }
}
