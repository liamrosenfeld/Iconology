//
//  ImageOptionsViewController.swift
//  Iconology
//
//  Created by Liam on 1/21/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

protocol ImageOptionsDelegate {
    func modsChanged(_ mods: ImageModifications)
}

class ImageOptionsViewController: NSViewController {
    // MARK: - Setup
    var mods = ImageModifications()
    var delegate: ImageOptionsDelegate?
    
    override func viewDidLoad() {
        _ = self.view // Load View Hierarchy
        prefixPreview.stringValue = ""
        shiftSelector.target = self
        shiftSelector.action = #selector(shiftSelected)
    }

    // MARK: - Outlets
    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var backgroundToggle: NSButton!
    @IBOutlet weak var backgroundColor: NSColorWell!
    
    @IBOutlet weak var scaleView: NSView!
    @IBOutlet weak var scaleSlider: NSSlider!
    
    @IBOutlet weak var shiftView: NSView!
    @IBOutlet weak var shiftSelector: PositionSelector!
    
    @IBOutlet weak var roundView: NSView!
    @IBOutlet weak var roundSlider: NSSlider!
    
    @IBOutlet weak var prefixView: NSView!
    @IBOutlet weak var prefixTextBox: NSTextField!
    @IBOutlet weak var prefixPreview: NSTextField!
    
    // MARK: - Parent Interactions
    func setMods(from preset: Preset) {
        let useMod = preset.useModifications
        backgroundView.isHidden = !useMod.background
        scaleView.isHidden      = !useMod.scale
        shiftView.isHidden      = !useMod.shift
        roundView.isHidden      = !useMod.round
        prefixView.isHidden     = !useMod.prefix
    }
    
    var prefix: String {
        get {
            return prefixTextBox.stringValue
        }
    }
    
    // MARK: - Actions
    
    // Background
    @IBAction func backgroundToggled(_ sender: Any) {
        switch backgroundToggle.state {
        case .on:
            mods.background = backgroundColor.color
        case .off:
            mods.background = nil
        default:
            print("ERR: Wrong Button State")
        }
        delegate?.modsChanged(mods)
    }
    
    @IBAction func backgroundColorSelected(_ sender: Any) {
        backgroundToggled(self)
    }
    
    // Scale
    @IBAction func scaleSelected(_ sender: Any) {
        mods.scale = CGFloat(scaleSlider.doubleValue)
        delegate?.modsChanged(mods)
    }
    
    @IBAction func resetScale(_ sender: Any) {
        mods.scale = 1
        scaleSlider.doubleValue = 1
        delegate?.modsChanged(mods)
    }
    
    
    // Shift
    @objc func shiftSelected(_ sender: Any) {
        let shift = shiftSelector.position
        mods.shift = shift
        delegate?.modsChanged(mods)
    }
    
    @IBAction func resetShift(_ sender: Any) {
        mods.shift = .zero
        shiftSelector.setPosition(to: .zero)
        delegate?.modsChanged(mods)
    }
    
    // Round
    @IBAction func roundSelected(_ sender: Any) {
        mods.rounding = CGFloat(roundSlider.doubleValue)
        delegate?.modsChanged(mods)
    }
    
    @IBAction func roundReset(_ sender: Any) {
        mods.rounding = CGFloat(roundSlider.doubleValue)
        roundSlider.doubleValue = 0
        delegate?.modsChanged(mods)
    }
    
    // Prefix
    @IBAction func prefixTextEdited(_ sender: Any) {
        let prefix = prefixTextBox.stringValue
        prefixPreview.stringValue = "Ex: \(prefix)root.type"
    }
}

struct ImageModifications {
    var background: NSColor?
    var shift: CGPoint = .zero
    var scale: CGFloat = 1
    var aspect: NSSize = NSSize(width: 1, height: 1)
    var rounding: CGFloat = 0
    
    func apply(on image: NSImage) -> NSImage {
        var modImage = image
        
        modImage = modImage.transform(aspect: aspect, scale: scale, shift: shift)
        
        if let backgroundColor = background {
            modImage = modImage.addBackground(backgroundColor)
        }
        
        if rounding != 0 {
            modImage = modImage.round(percent: rounding)
        }
        
        return modImage
    }
}
