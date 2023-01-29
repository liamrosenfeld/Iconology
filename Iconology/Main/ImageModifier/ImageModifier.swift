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
    @Published var size: CGSize
    @Published var scale: CGFloat
    @Published var shift: CGPoint
    @Published var background: Background
    @Published var rounding: Rounding
    @Published var padding: CGFloat
    @Published var shadow: ShadowAttributes
    @Published var colorSpace: CGColorSpace
    
    private var editor: ImageEditor!
     
    // MARK: - In and Out
    @Published var origImage: CGImage?
    @Published private(set) var finalImage: CGImage?

    // MARK: - Init
    init() {
        size = CGSize(width: 100, height: 100)
        scale = 100
        shift = .zero
        background = .none
        rounding = (0, .circular)
        padding = 0
        shadow = (0, 0)
        colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        editor = ImageEditor()
    }
    
    convenience init(image: CGImage) {
        self.init()
        
        origImage = image
        if image.size != .zero {
            finalImage = editor.newImage(image, mods: mods())
        }
    }

    func observeChanges() {
        // share pubs that need both immediate and after
        let scalePub = $scale.share()
        let paddingPub = $padding.share()
        
        // reacting to immediate changes
        $origImage
            .map { newCS in
                return self.editor.newImage(self.origImage, mods: self.mods())
            }
            .assign(to: &$finalImage)
        $size
            .map { newSize in
                var mods = self.mods()
                mods.size = newSize
                return self.editor.newSize(mods: mods)
            }
            .assign(to: &$finalImage)
        $colorSpace
            .map { newCS in
                var mods = self.mods()
                mods.colorSpace = newCS
                return self.editor.newImage(self.origImage, mods: mods)
            }
            .assign(to: &$finalImage)
        
        // throttled changes
        scalePub
            .map { newScale in
                var mods = self.mods()
                mods.scale = newScale
                return self.editor.newScale(mods: mods)
            }
            .assign(to: &$finalImage)
        $shift
            .map { newShift in
                var mods = self.mods()
                mods.shift = newShift
                return self.editor.newShift(mods: mods)
            }
            .assign(to: &$finalImage)
        $background
            .map { newBackground in
                var mods = self.mods()
                mods.background = newBackground
                return self.editor.newBackground(mods: mods)
            }
            .assign(to: &$finalImage)
        $rounding
            .map { newRounding in
                var mods = self.mods()
                mods.rounding = newRounding
                return self.editor.newRounding(mods: mods)
            }
            .assign(to: &$finalImage)
        paddingPub
            .map { newPadding in
                var mods = self.mods()
                mods.padding = newPadding
                return self.editor.newPadding(mods: mods)
            }
            .assign(to: &$finalImage)
        $shadow
            .map { newShadow in
                var mods = self.mods()
                mods.shadow = newShadow
                return self.editor.newShadow(mods: mods)
            }
            .assign(to: &$finalImage)
        
        // react to finished selecting
        let subs = DispatchQueue(label: "Sub", qos: .default)
        scalePub
            .debounce(for: .seconds(0.2), scheduler: subs, options: nil)
            .map { newScale in
                var mods = self.mods()
                mods.scale = newScale
                return self.editor.finishedScaling(mods: mods)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$finalImage)
        paddingPub
            .debounce(for: .seconds(0.2), scheduler: subs, options: nil)
            .map { newPadding in
                var mods = self.mods()
                mods.padding = newPadding
                return self.editor.finishedPadding(mods: mods)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$finalImage)
    }
    
    func mods() -> ImageModifications {
        ImageModifications(
            size: self.size,
            scale: self.scale,
            shift: self.shift,
            background: self.background,
            rounding: self.rounding,
            padding: self.padding,
            shadow: self.shadow,
            colorSpace: self.colorSpace
        )
    }
    
    // MARK: - Actions
    
    /// if the selected size is too small for the image,
    /// auto scale down the image so it fits
    func scaleToFit() {
        guard let imgSize = origImage?.size else { return }
        
        let widthScale  = size.width / imgSize.width
        let heightScale = size.height / imgSize.height
        
        let minScale = min(widthScale, heightScale)
        if minScale < 1 {
            scale = minScale * 100
            shift = .zero // bring it back to center
        }
    }
    
    func applyDefaults(_ defaults: DefaultModifications) {
        self.background = defaults.background
        self.rounding   = defaults.round
        self.padding    = defaults.padding
        self.shadow     = defaults.shadow
    }
}

enum RoundingStyle {
    case circular
    case continuous
    case squircle
}

typealias Rounding = (percent: CGFloat, style: RoundingStyle)

typealias ShadowAttributes = (opacity: CGFloat, blur: CGFloat)
