//
//  OptionsViewController.swift
//  Iconator
//
//  Created by Liam Rosenfeld on 2/1/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {
    
    // Setup
    @IBOutlet weak var xcodeVersionSelector: NSPopUpButton!
    @IBOutlet weak var iPhoneToggle: NSButton!
    @IBOutlet weak var iPadToggle: NSButton!
    @IBOutlet weak var macToggle: NSButton!
    
    var imageURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imageURL!)
    }
    
    // Actions
    @IBAction func convert(_ sender: Any) {
        let xcodeVersion = xcodeVersionSelector.titleOfSelectedItem!
        let iPhoneEnabled = iPhoneToggle.state.rawValue
        let iPadEnabled = iPadToggle.state.rawValue
        let macEnabled = macToggle.state.rawValue
        
        if xcodeVersion == "9" {
            if iPhoneEnabled == 1 {
                
            }
            if iPadEnabled == 1 {
                
            }
            if macEnabled == 1 {
                
            }
        } else if xcodeVersion == "8" {
            if iPhoneEnabled == 1 {
                
            }
            if iPadEnabled == 1 {
                
            }
            if macEnabled == 1 {
                
            }
        }
        
    }
    
}
