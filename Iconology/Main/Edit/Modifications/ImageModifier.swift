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
        editor = ImageEditor(self)
    }
    
    convenience init(image: CGImage) {
        self.init()
        
        origImage = image
        if image.size != .zero {
            finalImage = editor.newImage(image)
        }
    }

    func observeChanges() {
        // share pubs that need both immediate and after
        let scalePub = $scale.share()
        let paddingPub = $padding.share()
        
        // reacting to immediate changes
        $origImage
            .map(editor.newImage)
            .assign(to: &$finalImage)
        $size
            .map(editor.newSize)
            .assign(to: &$finalImage)
        $colorSpace
            .map(editor.newColorSpace)
            .assign(to: &$finalImage)
        
        // throttled changes
        scalePub
            .map(editor.newScale)
            .assign(to: &$finalImage)
        $shift
            .map(editor.newShift)
            .assign(to: &$finalImage)
        $background
            .map(editor.newBackground)
            .assign(to: &$finalImage)
        $rounding
            .map(editor.newRounding)
            .assign(to: &$finalImage)
        paddingPub
            .map(editor.newPadding)
            .assign(to: &$finalImage)
        $shadow
            .map(editor.newShadow)
            .assign(to: &$finalImage)
        
        // react to finished selecting
        let subs = DispatchQueue(label: "Sub", qos: .default)
        scalePub
            .debounce(for: .seconds(0.2), scheduler: subs, options: nil)
            .map(editor.finishedScaling)
            .receive(on: DispatchQueue.main)
            .assign(to: &$finalImage)
        paddingPub
            .debounce(for: .seconds(0.2), scheduler: subs, options: nil)
            .map(editor.finishedPadding)
            .receive(on: DispatchQueue.main)
            .assign(to: &$finalImage)
    }
    
    /// if the selected size is too small for the image,
    /// auto scale down the image so it fits
    func scaleToFit() {
        guard let imgSize = origImage?.size else { return }
        
        let widthScale  = size.width / imgSize.width
        let heightScale = size.height / imgSize.height
        
        let minScale = min(widthScale, heightScale)
        if minScale < 1 {
            scale = max(minScale * 100, 10) // don't scale it beyond reason
            shift = .zero // bring it back to center
        }
    }
}

enum RoundingStyle {
    case circular
    case continuous
    case squircle
}

typealias Rounding = (percent: CGFloat, style: RoundingStyle)

typealias ShadowAttributes = (opacity: CGFloat, blur: CGFloat)
