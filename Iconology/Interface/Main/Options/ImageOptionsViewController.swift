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
    @IBOutlet weak var scaleToggle: NSButton!
    @IBOutlet weak var scaleSlider: NSSlider!
    
    @IBOutlet weak var shiftView: NSView!
    @IBOutlet weak var shiftToggle: NSButton!
    @IBOutlet weak var shiftSelector: PositionSelector!
    
    @IBOutlet weak var roundView: NSView!
    @IBOutlet weak var roundToggle: NSButton!
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
    
    @IBAction func scaleToggled(_ sender: Any) {
        switch scaleToggle.state {
        case .on:
            mods.scale = CGFloat(scaleSlider.doubleValue)
        case .off:
            mods.scale = 1
        default:
            print("ERR: Wrong Button State")
        }
        delegate?.modsChanged(mods)
    }
    
    @IBAction func scaleSelected(_ sender: Any) {
        scaleToggled(self)
    }
    
    @IBAction func shiftToggled(_ sender: Any) {
        switch shiftToggle.state {
        case .on:
            let shift = shiftSelector.position
            mods.shift.width = shift.x
            mods.shift.height = shift.y
        case .off:
            mods.shift.width = 0
        default:
            print("ERR: Wrong Button State")
        }
        delegate?.modsChanged(mods)
    }
    
    @objc func shiftSelected(_ sender: Any) {
        shiftToggled(sender)
    }
    
    @IBAction func roundToggled(_ sender: Any) {
        switch roundToggle.state {
        case .on:
            mods.rounding = CGFloat(roundSlider.doubleValue)
        case .off:
            mods.rounding = 0
        default:
            print("ERR: Wrong Button State")
        }
        delegate?.modsChanged(mods)
    }
    
    @IBAction func roundSelected(_ sender: Any) {
        roundToggled(self)
    }
    
    @IBAction func prefixTextEdited(_ sender: Any) {
        let prefix = prefixTextBox.stringValue
        prefixPreview.stringValue = "Ex: \(prefix)root.type"
    }
}

struct ImageModifications {
    var background: NSColor?
    var shift: NSSize = NSSize(width: 0, height: 0) // TODO: CGPoint
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
