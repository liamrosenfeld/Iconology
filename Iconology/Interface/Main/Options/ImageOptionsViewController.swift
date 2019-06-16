//
//  ImageOptionsViewController.swift
//  Iconology
//
//  Created by Liam on 1/21/19.
//  Copyright © 2019 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class ImageOptionsViewController: NSViewController {
    // MARK: - Setup
    var mods = ImageModifier(image: NSImage())
    
    override func viewDidLoad() {
        _ = self.view // Load View Hierarchy
        prefixPreview.stringValue = ""
        shiftSelector.target = self
        shiftSelector.action = #selector(shiftSelected)
        resetAll()
    }

    // MARK: - Outlets
    @IBOutlet weak var backgroundView: NSView!
    @IBOutlet weak var backgroundToggle: NSButton!
    @IBOutlet weak var backgroundColor: NSColorWell!
    
    @IBOutlet weak var scaleView: NSView!
    @IBOutlet weak var scaleSlider: NSSlider!
    @IBOutlet weak var scaleText: NSTextField!
    
    @IBOutlet weak var shiftView: NSView!
    @IBOutlet weak var shiftSelector: PositionSelector!
    @IBOutlet weak var shiftXText: NSTextField!
    @IBOutlet weak var shiftYText: NSTextField!
    
    @IBOutlet weak var roundView: NSView!
    @IBOutlet weak var roundSlider: NSSlider!
    @IBOutlet weak var roundText: NSTextField!
    
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
    
    // MARK: -- Actions
    func resetAll() {
        resetScale(self)
        resetShift(self)
        resetRound(self)
    }
    
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
    }
    
    @IBAction func backgroundColorSelected(_ sender: Any) {
        backgroundToggled(self)
    }
    
    // Scale
    var shiftCount = 0
    @IBAction func scaleSelected(_ sender: Any) {
        // limit triggers
        shiftCount += 1
        if shiftCount % 2 == 0 {
            return
        }
        
        mods.scale = CGFloat(scaleSlider.doubleValue)
        scaleText.stringValue = scaleSlider.doubleValue.description
    }
    
    @IBAction func resetScale(_ sender: Any) {
        mods.scale = 1
        scaleSlider.doubleValue = 1
        scaleText.stringValue = "1"
    }
    
    @IBAction func scaleTyped(_ sender: Any) {
        guard let num = Double(scaleText.stringValue) else {
            return
        }
        
        if num <= 0 || num > 2 {
            return
        }
        
        mods.scale = CGFloat(num)
        scaleSlider.doubleValue = num
    }
    
    // Shift
    @objc func shiftSelected(_ sender: Any) {
        let shift = shiftSelector.position
        mods.shift = shift
        shiftXText.stringValue = shift.x.description
        shiftYText.stringValue = shift.y.description
    }
    
    @IBAction func resetShift(_ sender: Any) {
        mods.shift = .zero
        shiftSelector.setPosition(to: .zero)
        shiftXText.stringValue = "0"
        shiftYText.stringValue = "0"
    }
    
    @IBAction func shiftXTyped(_ sender: Any) {
        guard let num = Double(shiftXText.stringValue) else {
            return
        }
        
        if num < -120 || num > 120 {
            return
        }
        
        mods.shift.x = CGFloat(num)
        shiftSelector.setPosition(to: mods.shift)
    }
    
    @IBAction func shiftYTyped(_ sender: Any) {
        guard let num = Double(shiftYText.stringValue) else {
            return
        }
        
        if num < -120 || num > 120 {
            return
        }
        
        mods.shift.y = CGFloat(num)
        shiftSelector.setPosition(to: mods.shift)
    }
    
    // Round
    @IBAction func roundSelected(_ sender: Any) {
        mods.rounding = CGFloat(roundSlider.doubleValue)
        roundText.stringValue = roundSlider.doubleValue.description
    }
    
    @IBAction func resetRound(_ sender: Any) {
        mods.rounding = 0
        roundSlider.doubleValue = 0
        roundText.stringValue = "0"
    }
    
    @IBAction func roundTyped(_ sender: Any) {
        guard let num = Double(scaleText.stringValue) else {
            return
        }
        
        if num <= 0 || num >= 100 {
            return
        }
        
        mods.rounding = CGFloat(num)
        roundSlider.doubleValue = num
    }
    
    // Prefix
    @IBAction func prefixTextEdited(_ sender: Any) {
        let prefix = prefixTextBox.stringValue
        prefixPreview.stringValue = "Ex: \(prefix)root.type"
    }
}
