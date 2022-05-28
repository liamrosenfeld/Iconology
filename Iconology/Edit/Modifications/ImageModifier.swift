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
    
    private var subscribers = Set<AnyCancellable>()
    private var editor: ImageEditor!
     
    // MARK: - In and Out
    @Published var origImage: CGImage?
    @Published var finalImage: CGImage?

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
            editor.newImage(image)
        }
    }

    func observeChanges() {
        // share pubs that need both immediate and after
        let scalePub = $scale.share()
        let paddingPub = $padding.share()
        
        // reacting to immediate changes
        $origImage
            .sink(receiveValue: editor.newImage)
            .store(in: &subscribers)
        $size
            .sink(receiveValue: editor.newSize)
            .store(in: &subscribers)
        scalePub
            .sink(receiveValue: editor.newScale)
            .store(in: &subscribers)
        $shift
            .sink(receiveValue: editor.newShift)
            .store(in: &subscribers)
        $background
            .sink(receiveValue: editor.newBackground)
            .store(in: &subscribers)
        $rounding
            .sink(receiveValue: editor.newRounding)
            .store(in: &subscribers)
        paddingPub
            .sink(receiveValue: editor.newPadding)
            .store(in: &subscribers)
        $shadow
            .sink(receiveValue: editor.newShadow)
            .store(in: &subscribers)
        $colorSpace
            .sink(receiveValue: editor.newColorSpace)
            .store(in: &subscribers)

        // react to finished selecting
        let debounceTime: RunLoop.SchedulerTimeType.Stride = .seconds(0.2)
        scalePub
            .debounce(for: debounceTime, scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: editor.finishedScaling)
            .store(in: &subscribers)
        paddingPub
            .debounce(for: debounceTime, scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: editor.finishedPadding)
            .store(in: &subscribers)
    }
}

enum RoundingStyle {
    case circular
    case continuous
    case squircle
}

typealias Rounding = (percent: CGFloat, style: RoundingStyle)

typealias ShadowAttributes = (opacity: CGFloat, blur: CGFloat)
